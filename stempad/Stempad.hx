package stempad;
import cpp.*;

@:keep
@:include('Gamepad.h')
#if !display
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('stempad'))
#end

@:structAccess
@:unreflective
@:native('::Gamepad_device')
extern class GamepadDevice {
	var deviceID:Int;
	var description:ConstCharStar;
	var vendorID:Int;
	var productID:Int;
	var numAxes:Int;
	var numButtons:Int;
	var axisStates:Pointer<Float32>;
	var buttonStates:Pointer<Bool>;
	var privateData:Pointer<Void>;
}

extern class Stempad {

    //external native function definition
    //can be wrapped in linc::libname or call directly
    //and the header for the lib included in linc_stempad.h

    /*@:native('linc::stempad::example')
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
    }*/
	
	@:native('::Gamepad_init')
	static function gamepad_init():Void;
	
	@:native('::Gamepad_shutdown')
	static function gamepad_shutdown():Void;
	
	@:native('::Gamepad_numDevices')
	static function gamepad_numDevices():Int;
	
	//@:native('Gamepad_deviceAtIndex')
	static inline function gamepad_deviceAtIndex(deviceIndex:Int):GamepadDevice {
        return Pointer.fromRaw(untyped __cpp__('Gamepad_deviceAtIndex({0})', deviceIndex)).value;
    }
	
	@:native('Gamepad_detectDevices')
	static function gamepad_detectDevices():Void;
	
	@:native('Gamepad_processEvents')
	static function gamepad_processEvents():Void;
} 

//Stempad