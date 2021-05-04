const char HTML_PAGE[] =
    "<pre>use arrow keys</pre> <script>codes = [40,38,37,39];state = "
    "0;f=e=>{if (!codes.includes(e.keyCode)) return;state ^= (1 << "
    "codes.indexOf(e.keyCode));body = new FormData();body.append('state', "
    "state.toString());fetch('/', {method: 'POST', body })};for(let e of "
    "['keydown', 'keyup'])document.addEventListener(e,f);</script>";
