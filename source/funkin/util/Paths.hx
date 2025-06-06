package funkin.util;

import flixel.graphics.frames.FlxAtlasFrames;
import haxe.macro.Compiler;
import flixel.util.FlxSave;
import flixel.FlxG;
import haxe.io.Path;

final class Paths {
	public static inline var VIDEO_EXTENSION:String = 'mp4';

	@:access(flixel.util.FlxSave.validate)
	public static function buildSaveName():String {
		return FlxSave.validate(FlxG.stage.application.meta['file']);
	}

	@:access(flixel.util.FlxSave.validate)
	public static function buildSavePath():String {
		final company = FlxG.stage.application.meta['company'];
		final file = FlxG.stage.application.meta['file'];
		return FlxSave.validate(Path.join([company, file]));
	}

	public static function getLibrary(id:String):String {
		id = id.trim();
		final colon = id.indexOf(':');
		return colon > 0 ? id.substr(0, colon) : 'default';
	}

	public static function cutLibrary(id:String):String {
		id = id.trim();
		final colon = id.indexOf(':');
		return colon > 0 ? id.substr(colon + 1) : id;
	}

	public static function file(id:String, ?directory:String, ?extension:String):String {
		final library = getLibrary(id);

		final prefix = ![null, 'default'].contains(library) ? '$library:assets/$library/' : 'assets/';
		final suffix = extension != null ? asExtension(extension) : '';

		return directory != null ? prefix + asDirectory(directory) + id + suffix : '$prefix$id$suffix';
	}

	public static inline function font(id:String, extension:String = 'ttf'):String {
		return file(id, 'fonts', extension);
	}

	public static inline function image(id:String):String {
		return file(id, 'images', 'png');
	}

	public static inline function music(id:String):String {
		return file('$id/$id', 'music');
	}

	public static inline function sound(id:String):String {
		return file(id, 'sounds');
	}

	public static inline function video(id:String):String {
		return file(id, 'videos', VIDEO_EXTENSION);
	}

	public static inline function asDirectory(string:String):String {
		return string.fastCodeAt(string.length - 1) == '/'.code ? string : '$string/';
	}

	public static inline function asExtension(string:String):String {
		return string.fastCodeAt(0) == '.'.code ? string : '.$string';
	}

	public static function hasFrames(id:String):Bool {
		var description = file(id, 'images', 'txt');
		if (FlxG.assets.exists(description, TEXT))
			return true;

		description = file(id, 'images', 'json');
		if (FlxG.assets.exists(description, TEXT))
			return true;

		description = file(id, 'images', 'xml');
		if (FlxG.assets.exists(description, TEXT))
			return true;

		return false;
	}

	public static function getFrames(id:String):Null<FlxAtlasFrames> {
		var description = file(id, 'images', 'txt');
		if (FlxG.assets.exists(description, TEXT))
			return FlxAtlasFrames.fromSpriteSheetPacker(image(id), description);

		description = file(id, 'images', 'json');
		if (FlxG.assets.exists(description, TEXT))
			return FlxAtlasFrames.fromTexturePackerJson(image(id), description);

		description = file(id, 'images', 'xml');
		if (FlxG.assets.exists(description, TEXT))
			return FlxAtlasFrames.fromSparrow(image(id), description);

		return null;
	}

	public static inline function textureAtlas(id:String):String {
		return file(id, 'images');
	}
}
