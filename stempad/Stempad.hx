package stempad;
import cpp.Callable;
import cpp.Pointer;
import cpp.*;

@:keep
@:include('linc_stempad.h')
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
	
	@:native('Gamepad_deviceAtIndex')
	static function gamepad_deviceAtIndex(deviceIndex:Int):Pointer<GamepadDevice>;
	
	@:native('Gamepad_detectDevices')
	static function gamepad_detectDevices():Void;
	
	@:native('Gamepad_processEvents')
	static function gamepad_processEvents():Void;
	
	//callbacks
	@:native('Gamepad_deviceAttachFunc')
	private static function gamepad_deviceAttachFunc(callback:Callable<Pointer<GamepadDevice>->Pointer<Void>->Void>, context:Int):Void;
	
	static inline function addAttackCallback(func:StempadAttachRemoveCallback) : Void {
		@:privateAccess Stempad_helper.add_attach_callback(func);
	}
} 

typedef StempadAttachRemoveCallback = GamepadDevice -> Void;

typedef StempadButtonCallback = GamepadDevice -> Int -> Float -> Void;

typedef StempadAxisCallback = GamepadDevice -> Int -> Float -> Float -> Float -> Void;

private class Stempad_helper {
	
	static var attachFunc:StempadAttachRemoveCallback;
	static var attachAdded:Bool = false;
	static var removeFunc:StempadAttachRemoveCallback;
	static var buttonDownFunc:StempadButtonCallback;
	static var buttonUpFunc:StempadButtonCallback;
	static var axisCallback:StempadAxisCallback;
	
	static function add_attach_callback(callback:StempadAttachRemoveCallback) {
		attachFunc = callback;
		if (!attachAdded) {
			attachAdded = true;
			@:privateAccess Stempad.gamepad_deviceAttachFunc(cpp.Callable.fromStaticFunction(attach_callback), 0);
		}
	}
	
	static function attach_callback(_device:Pointer<GamepadDevice>, _context:Pointer<Void>) {
		if (attachFunc != null) {
			attachFunc(_device.value);
		}
		
	}
}

//Stempad