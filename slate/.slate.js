(function(slate) {
	'use strict';

	var modalKeystroke = "`,ctrl",
		unit = 1 / 12 * 100;

	/* Keystrokes available in modal mode */
	var modalModeKeystrokes = {
		/* Corners */
		'1': slate.operation('corner', { direction: 'top-left' }),
		'2': slate.operation('corner', { direction: 'top-right' }),
		'3': slate.operation('corner', { direction: 'bottom-right' }),
		'4': slate.operation('corner', { direction: 'bottom-left' }),

		/* Center */
		'c': slate.operation('move', { x: 'screenOriginX+(screenSizeX-windowSizeX)/2', y: 'screenOriginY+(screenSizeY-windowSizeY)/2', width: 'windowSizeX', height: 'windowSizeY' }),

		/* Fullscreen */
		'f': slate.operation('move', { x: 'screenOriginX', y: 'screenOriginY', width: 'screenSizeX', height: 'screenSizeY' }),

		/* Quarter-screen */
		'q': slate.operation('move', { x: 'windowTopLeftX', y: 'windowTopLeftY', width: 'screenSizeX/2', height: 'screenSizeY/2' }),

		/* Resize */
		// 'h:cmd': slate.operation('resize', { width: '-' + unit + '%', height: '+0' }),
		// 'j:cmd': slate.operation('resize', { width: '+0', height: '+' + unit + '%' }),
		// 'k:cmd': slate.operation('resize', { width: '+0', height: '-' + unit + '%' }),
		// 'l:cmd': slate.operation('resize', { width: '+' + unit + '%', height: '+0' }),
		// 'h:cmd,shift': slate.operation('resize', { width: '+' + unit + '%', height: '+0', anchor: 'bottom-right' }),
		// 'j:cmd,shift': slate.operation('resize', { width: '+0', height: '-' + unit + '%', anchor: 'bottom-right' }),
		// 'k:cmd,shift': slate.operation('resize', { width: '+0', height: '+' + unit + '%', anchor: 'bottom-right' }),
		// 'l:cmd,shift': slate.operation('resize', { width: '-' + unit + '%', height: '+0', anchor: 'bottom-right' }),

		/* Nudge */
		'h:toggle': slate.operation('nudge', { x: '-' + unit + '%', y: '+0' }),
		'j:toggle': slate.operation('nudge', { x: '+0', y: '+' + unit + '%' }),
		'k:toggle': slate.operation('nudge', { x: '+0', y: '-' + unit + '%' }),
		'l:toggle': slate.operation('nudge', { x: '+' + unit + '%', y: '+0' }),

		/* Throw */
		'[:toggle': slate.operation('throw', { screen: 'left' }),
		']:toggle': slate.operation('throw', { screen: 'right' }),

		/* Snapshot */
		'=': slate.operation('snapshot', { name: 'savedSnapshot' }),
		'`': slate.operation('activate-snapshot', { name: 'savedSnapshot' }),

		/* General */
		'u': slate.operation('undo'),
		'r': slate.operation('relaunch')
	};

	/* Keystrokes available in normal mode */
	var normalModeKeystrokes = {
		/* Grid */
		'space:ctrl': slate.operation('grid', {
			grids: {
				0: { width: 8, height: 8 },
				1: { width: 8, height: 8 }
			},
			padding: 1
		}),

		/* Hints */
		'esc:cmd': slate.operation('hint')
	};

	/* Attach the modal keystroke */
	_.each(modalModeKeystrokes, function(operation, keystroke) {
		var newKeystroke = keystroke.replace(/(:toggle)?$/, ':' + modalKeystroke + '$1');
		modalModeKeystrokes[newKeystroke] = operation;
		delete modalModeKeystrokes[keystroke];
	});

	/* Global configuration */
	slate.configAll({
		checkDefaultsOnLoad: true,
		defaultToCurrentScreen: true,
		modalEscapeKey: 'c:ctrl',
		gridBackgroundColor: '192;192;192;1',
		gridCellBackgroundColor: '0;0;0;1',
		gridCellSelectedColor: '255;255;255;.5',
		gridRoundedCornerSize: 2,
		gridCellRoundedCornerSize: 1
	});

	/* Bind all the keystrokes */
	slate.bindAll(modalModeKeystrokes);
	slate.bindAll(normalModeKeystrokes);
}(slate));
