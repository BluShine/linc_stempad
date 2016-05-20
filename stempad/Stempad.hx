package stempad;
import cpp.Uint16;

@:keep
@:include('linc_stempad.h')
@:keep
@:include('Gamepad.h')
#if !display
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('stempad'))
#end
extern class Stempad {

        //external native function definition
        //can be wrapped in linc::libname or call directly
        //and the header for the lib included in linc_stempad.h

    @:native('linc::stempad::example')
    static function example() : Int;

        //inline functions can be used as wrappers
        //and can be useful to juggle haxe typing to or from the c++ extern

    static inline function inline_example() : Int {
        return untyped __cpp__('linc::stempad::example()');
    }

    @:native('linc::stempad::example')
    private static function _internal_example() : Int;
    static inline function other_inline_example() : Int {
        return _internal_example();
    }
	
	@:native('::Gamepad_init')
	static function gamepad_init():Void;
	
	@:native('::Gamepad_shutdown')
	static function gamepad_shutdown():Void;
	
	@:native('::Gamepad_numDevices')
	static function gamepad_numDevices():Int;

} //Stempad