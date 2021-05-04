use iced::{
    button, executor, keyboard, Align, Application, Button, Checkbox, Clipboard, Column, Command,
    Container, Element, HorizontalAlignment, Length, Settings, Subscription, Text,
};
use iced_native::{
    keyboard::{
        Event::{KeyPressed, KeyReleased},
        KeyCode,
    },
    Event::{self, Keyboard},
};
use std::net::TcpStream;
use std::time::Duration;
use std::{io::prelude::*, time::Instant};

pub fn main() -> iced::Result {
    Events::run(Settings {
        ..Settings::default()
    })
}

#[derive(Debug, Clone, PartialEq)]
enum Direction {
    Left,
    Right,
    Up,
    Down,
    Exit,
}

impl Direction {
    fn from_keycode(key: KeyCode) -> Option<Self> {
        match key {
            KeyCode::Up => Some(Direction::Up),
            KeyCode::Down => Some(Direction::Down),
            KeyCode::Left => Some(Direction::Left),
            KeyCode::Right => Some(Direction::Right),
            KeyCode::Q => Some(Direction::Exit),
            _ => None,
        }
    }
}

#[derive(Debug)]
struct Events {
    car: Car,
    repeat: u8,
    last: (Direction, bool),
}
impl Events {
    fn new() -> Self {
        println!("new!");
        Events {
            car: Car::new(),
            repeat: 0,
            last: (Direction::Up, false),
        }
    }
    fn handle_move(&mut self, dir: &Option<Direction>, up: bool, fast: bool) {
        if dir.is_none() {
            return;
        };
        let dir = dir.as_ref().unwrap();
        if *dir == Direction::Exit {
            std::process::exit(0);
        }
        // if self.last.0 == *dir {
        //     self.repeat = if up {
        //         cmp::max(6, cmp::min(8, self.repeat + 1))
        //     } else {
        //         0
        //     }
        // }

        // let fade = (2u16.pow(self.repeat.into()) - 1) as u8;
        let fade = if up {
            if fast {
                255
            } else {
                160
            }
        } else {
            0
        };
        let fade_turn_offset = if fade > 90 { 90 } else { 0 };

        match dir {
            Direction::Up => {
                // We are in forward, negatives off.
                self.car.ln = 0;
                self.car.rn = 0;
                // Fade
                self.car.rp = fade;
                self.car.lp = self.car.rp;
            }
            Direction::Down => {
                // We are in reverse, positives off.
                self.car.lp = 0;
                self.car.rp = 0;
                // Fade
                self.car.rn = fade;
                self.car.ln = self.car.rn;
            }
            Direction::Left => {
                // Left: left on, right off
                self.car.ln = 0;
                self.car.rn = 0;
                self.car.rp = 0;
                // Fade
                self.car.lp = fade - fade_turn_offset;
                self.car.rn = fade - fade_turn_offset;
            }
            Direction::Right => {
                // Right: left off, right on
                self.car.rn = 0;
                self.car.lp = 0;
                // Fade
                self.car.rp = fade - fade_turn_offset;
                self.car.ln = fade - fade_turn_offset;
            }
            _ => {}
        }

        // Low pass filter as 2^0==1
        if self.car.rp == 1 {
            self.car.rp = 0;
        }
        if self.car.rn == 1 {
            self.car.rn = 0;
        }
        if self.car.lp == 1 {
            self.car.lp = 0;
        }
        if self.car.ln == 1 {
            self.car.ln = 0;
        }

        self.car.update().unwrap();
        self.last = (dir.clone(), up);
    }
}

#[derive(Debug, Clone)]
enum Message {
    EventOccurred(iced_native::Event),
}

impl Application for Events {
    type Executor = executor::Default;
    type Message = Message;
    type Flags = ();

    fn new(_flags: ()) -> (Events, Command<Message>) {
        (Events::new(), Command::none())
    }

    fn title(&self) -> String {
        String::from("esp32-car-remote controller")
    }

    fn update(&mut self, message: Message, _clipboard: &mut Clipboard) -> Command<Message> {
        match message {
            Message::EventOccurred(Keyboard(event)) => match event {
                KeyPressed {
                    key_code,
                    modifiers,
                } => self.handle_move(&Direction::from_keycode(key_code), true, modifiers.shift),
                KeyReleased {
                    key_code,
                    modifiers,
                } => self.handle_move(&Direction::from_keycode(key_code), false, modifiers.shift),
                _ => {}
            },
            _ => {}
        };

        Command::none()
    }

    fn subscription(&self) -> Subscription<Message> {
        iced_native::subscription::events().map(Message::EventOccurred)
    }

    fn view(&mut self) -> Element<Message> {
        let content = Column::new().align_items(Align::Center);

        Container::new(content)
            .width(Length::Fill)
            .height(Length::Fill)
            .center_x()
            .center_y()
            .into()
    }
}

#[derive(Debug)]
struct Car {
    // {right,left}{positive,negative}
    rp: u8,
    rn: u8,
    lp: u8,
    ln: u8,
    last_written: [u8; 4],
    sock: TcpStream,
    // Last Written Miss
    lw_miss: bool,
    lw_miss_fix: bool,
    lw_miss_at: Option<Instant>,
}
impl Car {
    fn new() -> Self {
        println!("Car::new");
        let args: Vec<_> = std::env::args().collect();
        if args.len() < 2 {
            eprintln!("Usage: client HOST:PORT");
        }

        let sock = TcpStream::connect(args.get(1).unwrap()).unwrap();
        sock.set_read_timeout(Some(Duration::from_millis(300)))
            .unwrap();
        Car {
            sock,
            rp: 0,
            rn: 0,
            lp: 0,
            ln: 0,
            last_written: [0u8; 4],
            lw_miss: false,
            lw_miss_fix: false,
            lw_miss_at: None,
        }
    }
    fn update(&mut self) -> Result<(), std::io::Error> {
        if let Some(lwma) = self.lw_miss_at {
            if lwma.elapsed().as_secs() > 1 {
                return Ok(());
            }
        }
        let mut buf = &[self.rn, self.rp, self.ln, self.lp];
        if self.last_written != *buf {
            println!("user\tbuf:{:?}", buf);
            self.sock.write(buf)?;
            self.last_written = *buf;
        } else if self.lw_miss {
            // if this is because of lw_miss (bad connection usually) then just stop to avoid damage / collison
            buf = &[0u8; 4];
            println!("lw_miss\tbuf:{:?}", buf);
            self.sock.write(buf)?;
            self.last_written = *buf;
            self.lw_miss_fix = true;
        }

        let mut buf = [0u8];
        if self.sock.read(&mut buf).is_err() {
            self.lw_miss = true;
            self.update()?;
        } else if self.lw_miss_fix {
            self.lw_miss = false;
        }
        if buf[0] != 0 {
            eprintln!("drv8833 fault: {}", buf[0]);
        }

        Ok(())
    }
}
