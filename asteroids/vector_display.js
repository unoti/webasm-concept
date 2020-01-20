export class VectorDisplay {
    constructor(canvas) {
        this.canvas = canvas;
        this.max_x = canvas.width;
        this.max_y = canvas.height;
        this.isGunOn = false;
        this.background = 'black';
        this.foreground = 'white';
        this.move_to(this.max_x/2, this.max_y/2);
        // Draw list format:
        // Array of polylines.
        // Polyline is an array of points to connect.
        // A point is an array of x,y coordinates.
        this._polylines = []; // List of drawing operations to do when we render.
        this._polyline_points = []; // Current line path we're building.
    }

    gun = (on) => {
        this.isGunOn = on;
        if (on) {
            this._polyline_add();
        } else {
            this._polyline_close();
        }
    }

    move_to = (x, y) => {
        this.pos_x = x;
        this.pos_y = y;
        if (this.isGunOn) {
            this._polyline_add();
        }
    }

    render = () => {
        // If we've been drawing a line, stop it now.
        this._polyline_close();
        var ctx = this.canvas.getContext('2d');

        ctx.fillStyle = this.background;
        ctx.fillRect(0, 0, this.max_x, this.max_y);
        ctx.strokeStyle = this.foreground;

        while (this._polylines.length) {
            var polyline = this._polylines.pop();
            var startPt = polyline.pop();
            ctx.beginPath();
            ctx.moveTo(startPt[0], startPt[1]);
            while (polyline.length) {
                var pt = polyline.pop();
                ctx.lineTo(pt[0], pt[1]);
            }
            ctx.stroke();
        }

    }

    _polyline_add = () => {
        if (this._polyline_points.length) {
            var last = this._polyline_points[this._polyline_points.length-1];
            if (last[0] == this.pos_x && last[1] == this.pos_y)
                return;
        }
        this._polyline_points.push([this.pos_x, this.pos_y]);
    }

    // If we have a pending polyline, close it off and add it to the draw list.
    _polyline_close = () => {
        if (!this._polyline_points.length)
            return;
        this._polylines.push(this._polyline_points);
        this._polyline_points = [];
    }
}