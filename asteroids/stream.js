/**
 * OutputStream accepts characters one at a time, buffers them, and prints to
 * the console when it receives a '\n'.
 */
export class OutputStream {
    constructor() {
        this.buffer = "";
    }

    putc_int = (c_int) => {
        if (c_int == 10) { // 10 is '\n'
            this.flush();
        } else {
            var c = String.fromCharCode(c_int);
            this.buffer += c;
        }
    }

    flush = () => {
        this.output(this.buffer);
    }

    output = (s) => {
        console.log(s);
    }
}