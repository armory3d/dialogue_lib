package armory.system;

import zui.Zui;

@:access(zui.Zui)
class Dialogue {

	static var d: TDialogue = null;
	static var line: TLine = null;
	static var ui: Zui = null;

	public static function open(dialogue: TDialogue) {
		d = dialogue;
	}

	public static function close() {
		d = null;
		line = null;
	}

	public static function init(zui: Zui) {
		ui = zui;
		iron.App.notifyOnUpdate(update);
		iron.App.notifyOnRender2D(draw);
	}

	static inline function hasReplies(line: TLine, num = 1): Bool {
		return line.replies != null && line.replies.length >= num;
	}

	static function getLine(id: Int): TLine {
		for (line in d.lines) if (line.id == id) return line;
		return null;
	}

	static function setLine(id: Int) {
		line = getLine(id);
		if (line.event != null) {
			var all = armory.system.Event.get(line.event);
			if (all != null) for (entry in all) entry.onEvent();
		}
	}

	static function update() {
		if (d == null || line == null) return;
		var kb = iron.system.Input.getKeyboard();

		if (line.replies == null) {
			if (kb.started("space")) close();
			return;
		}
		
		if (line.replies.length == 1) {
			if (kb.started("space")) setLine(line.replies[0]);
			return;
		}

		for (i in 0...line.replies.length) {
			if (kb.started((i + 1) + "")) {
				var answer = getLine(line.replies[i]);
				hasReplies(answer) ? setLine(answer.replies[0]) : close();
				return;
			}
		}
	}

	static function draw(g: kha.graphics2.Graphics) {
		if (d == null || ui == null) return;
		if (line == null) line = d.lines[0];

		g.end();
		ui.begin(g);
		ui.g = g;

		ui._x = 0;
		ui._y = 0;
		ui._w = 600;

		ui.text(line.text);

		if (hasReplies(line, 2)) {
			for (i in 0...line.replies.length) {
				ui.text((i + 1) + ": " + getLine(line.replies[i]).text);
			}
		}

		ui.end();
		g.begin(false);
	}
}

typedef TDialogue = {
	var lines: Array<TLine>;
	@:optional var locales: Array<TLocale>;
}

typedef TLine = {
	var id: Int;
	var text: String;
	@:optional var replies: Array<Int>; // Line ids, null ends the dialogue
	@:optional var event: String;
	@:optional var character: String; // Defaults to player
}

typedef TLocale = {
	var name: String; // "en"
	var texts: Array<TTranslatedText>;
}

typedef TTranslatedText = {
	var id: Int; // element id
	var text: String;
}
