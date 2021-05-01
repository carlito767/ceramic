package ceramic;

/** RGBA Color stored as integer.
    Can be decomposed to Color/Int (RGB) + Float (A) and
    constructed from Color/Int (RGB) + Float (A). */
abstract AlphaColor(Int) from Int from UInt to Int to UInt {

    /**
     * Red color component as `Int` between `0` and `255`
     */
    public var red(get, set):Int;
    /**
     * Green color component as `Int` between `0` and `255`
     */
    public var green(get, set):Int;
    /**
     * Blue color component as `Int` between `0` and `255`
     */
    public var blue(get, set):Int;
    /**
     * Alpha component as `Int` between `0` and `255`
     */
    public var alpha(get, set):Int;
    
    /**
     * Red color component as `Float` between `0.0` and `1.0`
     */
    public var redFloat(get, set):Float;
    /**
     * Green color component as `Float` between `0.0` and `1.0`
     */
    public var greenFloat(get, set):Float;
    /**
     * Blue color component as `Float` between `0.0` and `1.0`
     */
    public var blueFloat(get, set):Float;
    /**
     * Alpha component as `Float` between `0.0` and `1.0`
     */
    public var alphaFloat(get, set):Float;

    /**
     * RGB color component typed as `ceramic.Color`
     */
    public var color(get, set):Color;

    /**
     * RGB color component typed as `ceramic.Color` (alias of `color`)
     */
    public var rgb(get, set):Color;

    /**
     * Create a new `AlphaColor` (ARGB) object from a `ceramic.Color` object and the given `alpha`
     * @param color RGB color object (`ceramic.Color`)
     * @param alpha alpha component between `0` and `255`
     */
    public inline function new(color:Color, alpha:Int = 255) {
        var value:AlphaColor = Std.int(color) + 0xFF000000;
        value.alpha = alpha;
        this = value;
    }

    inline function get_color():Color {
        return Color.fromRGB(red, green, blue);
    }
    inline function set_color(color:Color):Color {
        red = color.red;
        green = color.green;
        blue = color.blue;
        return color;
    }

    inline function get_rgb():Color {
        return Color.fromRGB(red, green, blue);
    }
    inline function set_rgb(color:Color):Color {
        red = color.red;
        green = color.green;
        blue = color.blue;
        return color;
    }
    
    private inline function get_red():Int {
        return (this >> 16) & 0xff;
    }
    
    private inline function get_green():Int {
        return (this >> 8) & 0xff;
    }
    
    private inline function get_blue():Int {
        return this & 0xff;
    }
    
    private inline function get_alpha():Int {
        return (this >> 24) & 0xff;
    }
    
    private inline function get_redFloat():Float {
        return red / 255;
    }
    
    private inline function get_greenFloat():Float {
        return green / 255;
    }
    
    private inline function get_blueFloat():Float {
        return blue / 255;
    }
    
    private inline function get_alphaFloat():Float {
        return alpha / 255;
    }
    
    private inline function set_red(Value:Int):Int {
        this &= 0xff00ffff;
        this |= boundChannel(Value) << 16;
        return Value;
    }
    
    private inline function set_green(Value:Int):Int {
        this &= 0xffff00ff;
        this |= boundChannel(Value) << 8;
        return Value;
    }
    
    private inline function set_blue(Value:Int):Int {
        this &= 0xffffff00;
        this |= boundChannel(Value);
        return Value;
    }
    
    private inline function set_alpha(Value:Int):Int {
        this &= 0x00ffffff;
        this |= boundChannel(Value) << 24;
        return Value;
    }
    
    private inline function set_redFloat(Value:Float):Float {
        red = Math.round(Value * 255);
        return Value;
    }
    
    private inline function set_greenFloat(Value:Float):Float {
        green = Math.round(Value * 255);
        return Value;
    }
    
    private inline function set_blueFloat(Value:Float):Float {
        blue = Math.round(Value * 255);
        return Value;
    }
    
    private inline function set_alphaFloat(Value:Float):Float {
        alpha = Math.round(Value * 255);
        return Value;
    }

    private inline function boundChannel(value:Int):Int {
        return value > 0xff ? 0xff : value < 0 ? 0 : value;
    }

    /**
     * Return a String representation of the color in the format
     *
     * @param prefix Whether to include "0x" prefix at start of string
     * @return    A string of length 10 in the format 0xAARRGGBB
     */
    public inline function toHexString(prefix:Bool = true):String
    {
        return (prefix ? "0x" : "") +
            StringTools.hex(alpha, 2) + StringTools.hex(red, 2) + StringTools.hex(green, 2) + StringTools.hex(blue, 2);
    }

/// To string

    /**
     * Get this RGBA color as `String`.
     * Format: `0xAARRGGBB`
     */
    inline public function toString() {

        return toHexString();

    }

}
