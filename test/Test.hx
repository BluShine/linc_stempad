import cpp.Callable;
import cpp.vm.Thread;
import haxe.Log;
import stempad.Stempad;
import cpp.Pointer;
import cpp.ConstCharStar;
import cpp.Float32;

class Test {
    static function main() {

        trace(stempad.Stempad.example());
		
		Stempad.gamepad_init();
		var numDevices:Int = Stempad.gamepad_numDevices();
		trace(numDevices);
		
		for (i in 0 ... numDevices) {
			var device:GamepadDevice = Stempad.gamepad_deviceAtIndex(i).value;
			trace("Pad " + Std.string(device.deviceID));
			trace("\tdescription: " + device.description.toString());
			//vendor and product IDs are 4-digit hex numbers.
			//there's a useful list at http://www.linux-usb.org/usb.ids
			trace("\tvendor: " + StringTools.hex(device.vendorID, 4));
			trace("\tproduct: " + StringTools.hex(device.productID, 4));
			trace("\taxes: " + Std.string(device.numAxes));
			trace("\tbuttons: " + Std.string(device.numButtons));
		}
		var inputThread:Thread = Thread.create(inputLoop);
		trace("press any key to exit");
		Sys.getChar(false);
		inputThread.sendMessage(1);
		trace("shutting down");
		Stempad.gamepad_shutdown();
    }
	
	static function inputLoop() {
		while (Thread.readMessage(false) == null) {
			Stempad.gamepad_detectDevices();
			Stempad.gamepad_processEvents();
			//trace(Stempad.gamepad_numDevices());
			for (i in 0 ... Stempad.gamepad_numDevices()) {
				var device:GamepadDevice = Stempad.gamepad_deviceAtIndex(i).value;
				for (i in 0 ... device.numButtons) {
					var states:Pointer<Bool> = device.buttonStates;
					if (states.add(i).ref == true) {
						trace("P" + Std.string(device.deviceID) + " button " + i);
					}
				}
				for (i in 0 ... device.numAxes) {
					var aStates:Pointer<Float32> = device.axisStates;
					var axisVal:Float = aStates.add(i).ref;
					if(Math.abs(axisVal) > .15 && Math.abs(axisVal) != 1)
						trace("P" + Std.string(device.deviceID) + " axis " + i + axisVal);
				}
			}
		}
	}
}