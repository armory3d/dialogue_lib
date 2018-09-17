package arm;

import iron.system.Input;
import iron.math.Vec4;
import iron.data.Data;
import iron.object.Object;
import iron.Scene;
import armory.system.Dialogue;

class TalkTrait extends iron.Trait {

	var player:Object;

	public function new() {
		super();

		notifyOnInit(function() {
			player = iron.Scene.active.getChild("Player");
			Data.getFont('droid_sans.ttf', function(font:kha.Font) {
				Dialogue.init(new zui.Zui({ font: font, scaleFactor: 3.0 }));
				notifyOnUpdate(update);
			});
		});
	}

	function update() {
		var action = Input.getKeyboard().started("e");
		if (action && Vec4.distance(object.transform.loc, player.transform.loc) < 2) {
			Data.getBlob("test_dialogue.json", function(b:kha.Blob) {
				var d:TDialogue = haxe.Json.parse(b.toString());
				Dialogue.open(d);
			});
		}
	}
}
