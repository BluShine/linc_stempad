import stempad.Stempad;

class Test {
        
    static function main() {

        trace(stempad.Stempad.example());
		
		Stempad.gamepad_init();
		trace(Stempad.gamepad_numDevices());
		Stempad.gamepad_shutdown();
    }

}