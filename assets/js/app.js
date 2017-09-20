// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import Clipboard from "clipboard";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

// https://stackoverflow.com/a/3150370
$('.pton-show-slug').on("click", function () {
   $(this).select();
});

$(function () {
	const clipboard = new Clipboard('.copy-link');

	clipboard.on('success', function(e) {
		$('.copy-link')
		.removeClass('btn-default')
		.addClass('btn-success');

		setTimeout(() => {
			$('.copy-link')
			.removeClass('btn-success')
			.addClass('btn-default');
		}, 1000);
	});

	clipboard.on('error', function(e) {
		$('.copy-link')
		.removeClass('btn-default')
		.addClass('btn-danger');

		setTimeout(() => {
			$('.copy-link')
			.removeClass('btn-danger')
			.addClass('btn-default');
		}, 1000);
	});
})
