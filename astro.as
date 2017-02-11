stop();

var OptionsOpen;
var WASD;
var Momentum;

var GameScore;

var GamePaused;
var GamePauseEnabled;
var GamePauseEnabledTiming;

var Alive;
var StartHealth;
var Health;
var StartLives;
var Lives;
var LivesCounter;
var TimeToRespawn;
var RespawnAttempts;
var spawn:uint;

var RotateLeft;
var RotateRight;
var PlaneRotateSpeedLimit;
var PlaneRotateSpeedForward;
var PlaneRotateSpeed;
var PlaneRotating;
var PlaneForward;
var PlaneForwardSpeed;
var PlaneVX;
var PlaneVY;
var PlaneFriction;
var PlaneLimitTemp;

var BounceEnabled:Boolean;
var BounceSpeed;

var Firing;
var BulletSpeed;
var BulletCount;
var BulletsEnabled;
var BulletsEnabledTiming;
var ActiveBulletCount;

var Bullets:Array = new Array();
var BulletsFiring:Array = new Array();
var BulletsVX:Array = new Array();
var BulletsVY:Array = new Array();
var BulletsDamage:Array = new Array();

var PowerBulletsLimit;
var PowerBullets;
var PowerMode;
var Blam;
var AngleChange;
var AngleDirection;

var EnemyModesCount;

var EnemyModesHealth:Array = new Array();
var EnemyModesRotationSpeed:Array = new Array();
var EnemyModesSpeedLimit:Array = new Array();
var EnemyModesMovementTypical:Array = new Array();
var EnemyModesScoreReward:Array = new Array();
var EnemyModesGemOdds:Array = new Array();

var EnemyCount;
var ActiveEnemyCount;

var Enemies:Array = new Array();
var EnemiesActive:Array = new Array();
var EnemiesMode:Array = new Array();
var EnemiesHealth:Array = new Array();
var EnemiesSpeed:Array = new Array();
var EnemiesVX:Array = new Array();
var EnemiesVY:Array = new Array();
var EnemiesRotationDirection:Array = new Array();

var WaveCount;

var AtWave;
var TimeBetweenWaves;
var Waves:Array = new Array();

var GemModeCount;
var GemLimit;
var GemSpeed;
var GemRotationSpeed;
var GemsActiveCount;
var FrustrationStart;
var Frustration;

var Gems:Array = new Array();
var GemsActive:Array = new Array();
var GemsMode:Array = new Array();
var GemsVX:Array = new Array();
var GemsVY:Array = new Array();
var GemsRotationDirection:Array = new Array();

var SplodeLimit;

var Splodes:Array = new Array();
var SplodesActive:Array = new Array();

var SoundOn:Boolean;
var SoundShoot;

SetUpGame();

function SetUpGame():void
{
	SetMenu();
	SetSounds();
	SetInitialValues();
	AddListeners();
	
	// The number is the starting wave (typically 0).
	SetUpWave(0);
}

function SetMenu():void
{
	var astromenu = new ContextMenu();
	astromenu.hideBuiltInItems();
	var astronote1 = new ContextMenuItem("Daniel John Benton");
	var astronote2 = new ContextMenuItem("2011");
	astromenu.customItems.push(astronote1, astronote2);
	contextMenu = astromenu;
}

function SetSounds():void
{
	SoundShoot = new shootsound();
}

function SetInitialValues():void
{
	OptionsOpen = false;
	
	GameScore = 0;
	scoretext.score.text = 0;
	
	WASD = false;
	SoundOn = false;
	
	Momentum = false;
	
	// Pause settings
	pausedtext.visible = false;
	N50(pausedtext);
	GamePaused = false;
	GamePauseEnabled = true;
	GamePauseEnabledTiming = 300;
	
	// Health and lives
	Alive = true;
	StartHealth = 10;
	Health = StartHealth;
	StartLives = 3;
	Lives = StartLives;
	LivesCounter = 0;
	TimeToRespawn = 2000;
	RespawnAttempts = 0;
	
	health.gotoAndStop(Health);
	livestext.lives.text = Lives;
	
	// Plane rotation
	RotateLeft = false;
	RotateRight = false;
	PlaneRotateSpeedLimit = 10;
	PlaneRotateSpeed = 0;
	PlaneRotateSpeedForward = 7;
	
	// Plane movement
	plane.cacheAsBitmap = true;
	
	PlaneForward = false;
	
	PlaneVX = 0;
	PlaneVY = 0;
	PlaneFriction = 0.95;
	PlaneForwardSpeed = 0.8;
	PlaneLimitTemp = 15;
	
	BounceEnabled = true;
	BounceSpeed = 7;
	
	Centre(plane);
	
	// Bullets
	Firing = false;
	BulletSpeed = 24;
	BulletCount = 20;
	BulletsEnabled = true;
	BulletsEnabledTiming = 150;
	ActiveBulletCount = 0;
	
	for(var iBullets:int = 0; iBullets < BulletCount; iBullets++)
	{
		BulletsFiring[iBullets] = false;
		
		Bullets[iBullets] = new planebullet();
		addChild(Bullets[iBullets]);
		N50(Bullets[iBullets]);
		Bullets[iBullets].cacheAsBitmap = true;
		
		BulletsVX[iBullets] = 0;
		BulletsVY[iBullets] = 0;
		
		BulletsDamage[iBullets] = 1;
	}
	
	// Bullets - power modes
	PowerBulletsLimit = 101;
	PowerBullets = 0;
	PowerMode = 1;
	Blam = false;
	AngleChange = 10;
	AngleDirection = false;
	
	power.gotoAndStop(1);
	
	// Gems - before enemies so they are underneath
	GemModeCount = 11;
	GemLimit = 3;
	GemSpeed = 3;
	GemRotationSpeed = 1;
	GemsActiveCount = 0;
	FrustrationStart = 20;
	Frustration = FrustrationStart;
	
	for(var iGems:int = 0; iGems < GemLimit; iGems++)
	{
		Gems[iGems] = new gem();
		addChild(Gems[iGems]);
		N50(Gems[iGems]);
		GemsActive[iGems] = false;
		GemsMode[iGems] = 1;
		GemsVX[iGems] = 0;
		GemsVY[iGems] = 0;
	}
	
	// Enemy modes
	EnemyModesCount = 0;
	SetEnemyModes();
	
	// Enemies
	EnemyCount = 50;
	ActiveEnemyCount = 0;
	
	for(var iEnemies:int = 0; iEnemies < EnemyCount; iEnemies++)
	{
		Enemies[iEnemies] = new enemy();
		addChild(Enemies[iEnemies]);
		N50(Enemies[iEnemies]);
		EnemiesActive[iEnemies] = false;
		EnemiesMode[iEnemies] = 1;
		EnemiesSpeed[iEnemies] = 0;
	}
	
	// Waves
	AtWave = 0;
	TimeBetweenWaves = 2000;
	
	SetWaves();
	
	// Layer plane behind explosions
	BringToFront(plane);
	
	// Explosions
	SplodeLimit = 15;
	
	for(var iSplodes:int = 0; iSplodes < SplodeLimit; iSplodes++)
	{
		Splodes[iSplodes] = new splode();
		addChild(Splodes[iSplodes]);
		Splodes[iSplodes].gotoAndStop(1);
		Splodes[iSplodes].x = -50;
		Splodes[iSplodes].y = -50;
		SplodesActive[iSplodes] = false;
	}
	
	wavetext.alpha = 70;
	
	// safe area
	safearea.visible = false;
	//Centre(safearea);
	N50(safearea);
	safearea.cacheAsBitmap = true;
	
	// options
	options.cacheAsBitmap = true;
	options.visible = false;
	N50(options);
	//Centre(options);
	//options.y += 100;
	
	optionspanel.momentum.hit.alpha = 0;
	N50(optionspanel);
	
	// Set layers
	BringToFront(scoretext);
	BringToFront(health);
	BringToFront(livestext);
	BringToFront(power);
	BringToFront(wavetext);
	BringToFront(pausedtext);
	BringToFront(options);
	BringToFront(optionspanel);
	
	scoretext.cacheAsBitmap = true;
	health.cacheAsBitmap = true;
	livestext.cacheAsBitmap = true;
	power.cacheAsBitmap = true;
	pausedtext.cacheAsBitmap = true;
	//wavetext.cacheAsBitmap = true;
	
}

function AddListeners():void
{
	stage.addEventListener(Event.ENTER_FRAME, GameLoop);
	stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
	stage.addEventListener(KeyboardEvent.KEY_UP, KeyUpHandler);
}

function KeyDownHandler(event:KeyboardEvent):void
{
	if(!GamePaused)
	{
		if(event.keyCode == Keyboard.SPACE)
		{
			Firing = true;
		}
		else if(event.keyCode == 80)
		{
			PauseGame(true);
		}
		else
		{
			if(WASD)
			{
				
				switch(event.keyCode)
				{
					case 65:
					{
						RotateLeft = true;
						break;
					}
					case 68:
					{
						RotateRight = true;
						break;
					}
					case 87:
					{
						PlaneForward = true;
						break;
					}
					default:
					{
						break;
					}
				}
				
			}
			else
			{
				
				switch(event.keyCode)
				{
					case Keyboard.LEFT:
					{
						RotateLeft = true;
						break;
					}
					case Keyboard.RIGHT:
					{
						RotateRight = true;
						break;
					}
					case Keyboard.UP:
					{
						PlaneForward = true;
						break;
					}
					default:
					{
						break;
					}
				}
				
			}
		}
	}
	else
	{
		if(event.keyCode == 80)
		{
			PauseGame(false);
		}
	}
}

function KeyUpHandler(event:KeyboardEvent):void
{
	if(event.keyCode == Keyboard.SPACE)
	{
		Firing = false;
	}
	else
	{
		
		if(WASD)
		{
			switch(event.keyCode)
			{
				case 65:
				{
					RotateLeft = false;
					break;
				}
				case 68:
				{
					RotateRight = false;
					break;
				}
				case 87:
				{
					PlaneForward = false;
					break;
				}
				default:
				{
					break;
				}
			}
		}
		else
		{
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
				{
					RotateLeft = false;
					break;
				}
				case Keyboard.RIGHT:
				{
					RotateRight = false;
					break;
				}
				case Keyboard.UP:
				{
					PlaneForward = false;
					break;
				}
				default:
				{
					break;
				}
			}
		}
	}
}

function PauseGame(pause:Boolean):void
{
	GamePaused = pause;
	
	pausedtext.visible = pause;
	options.visible = pause;
	
	if(pause)
	{
		Centre(pausedtext);
		Centre(options);
		options.y += 100;
		
		options.hit.addEventListener(MouseEvent.CLICK, ShowOptions);
	}
	else
	{
		N50(pausedtext);
		N50(options);
		
		if(!OptionsOpen)
		{
			options.hit.removeEventListener(MouseEvent.CLICK, ShowOptions);
		}
		else
		{
			optionspanel.momentum.hit.removeEventListener(MouseEvent.CLICK, SetMomentum);
			optionspanel.controls.hit.removeEventListener(MouseEvent.CLICK, SetControls);
			optionspanel.gotoAndStop(1);
			N50(optionspanel);
			OptionsOpen = false;
		}
		
	}
	
	if(!Alive)
	{
		if(pause)
		{
			clearTimeout(spawn);
		}
		else
		{
			if(Lives >= 1)
			{
				spawn = setTimeout(Respawn, 300);
			}
		}
	}
}

function ShowOptions(event:MouseEvent):void
{
	OptionsOpen = true;
	
	N50(options);
	options.hit.removeEventListener(MouseEvent.CLICK, ShowOptions);
	
	Centre(optionspanel);
	optionspanel.visible = true;
	optionspanel.gotoAndStop(2);
	var mframe = ((Momentum) ? 2 : 1);
	optionspanel.momentum.gotoAndStop(mframe);
	
	optionspanel.mouseEnabled = false;
	
	optionspanel.momentum.hit.addEventListener(MouseEvent.CLICK, SetMomentum);
	optionspanel.controls.hit.addEventListener(MouseEvent.CLICK, SetControls);
}

function SetMomentum(event:MouseEvent):void
{
	if(Momentum)
	{
		Momentum = false;
		PlaneFriction = 0.95;
		optionspanel.momentum.gotoAndStop(1);
	}
	else
	{
		Momentum = true;
		PlaneFriction = 1;
		optionspanel.momentum.gotoAndStop(2);
	}
}

function SetControls(event:MouseEvent):void
{
	if(WASD)
	{
		WASD = false;
		optionspanel.controls.gotoAndStop(1);
	}
	else
	{
		WASD = true;
		optionspanel.controls.gotoAndStop(2);
	}
}

function AddEnemyMode(EHealth:Number, ERSpeed:Number, ESpeedL:Number, EScoreR:Number, EGemOdds:Number, EMTypical:Boolean = true):void
{
	EnemyModesHealth.push(EHealth);
	EnemyModesRotationSpeed.push(ERSpeed);
	EnemyModesSpeedLimit.push(ESpeedL);
	EnemyModesMovementTypical.push(EMTypical);
	EnemyModesScoreReward.push(EScoreR);
	EnemyModesGemOdds.push(EGemOdds);
}

function SetEnemyModes():void
{
	//AddEnemyMode(Health, RSpeed, SpeedL, ScoreR, GemOdds, [typical])
	
	// 0 large asteroid
	AddEnemyMode(10, 3, 4, 1000, 3);
	
	var largeasteroidplace = 0;
	var larSpeed = EnemyModesRotationSpeed[largeasteroidplace];
	
	// 1 medium asteroid
	AddEnemyMode(5, larSpeed, 5, 500, 7);
	
	// 2 little asteroid
	AddEnemyMode(1, larSpeed, 6, 250, 500);
	
	// 3 behemoth asteroid
	AddEnemyMode(15, 0.5, 2, 3000, 2);
	
	// 4 large cracked asteroid
	AddEnemyMode(EnemyModesHealth[largeasteroidplace],
								EnemyModesRotationSpeed[largeasteroidplace],
								EnemyModesSpeedLimit[largeasteroidplace],
								EnemyModesScoreReward[largeasteroidplace],
								5);
								
	// 5 simple UFO
	AddEnemyMode(20, 0, 5, 5000, 3, false);
	
	// 6 UFO shard #1
	AddEnemyMode(4, 3, 3, 350, 10);
	
	// 7 UFO shard #2
	AddEnemyMode(4, 3, 3, 350, 10);
	
	// 8 Enemy bullet #1
	AddEnemyMode(1, 10, 6, 300, 250, false);
	
	// 9 Chasing enemy #1
	AddEnemyMode(13, 6, 3, 3000, 8, false);
	
	// 10 mining enemy
	AddEnemyMode(20, 0, 2, 2000, 3, false);
	
	// 11 miner bullet
	AddEnemyMode(1, 0, 7, 500, 500, false);
								
	EnemyModesCount = EnemyModesHealth.length;
	
}

function SetWaves():void
{
	
	/*
		To add a single item wave:
			Waves[n] = new Array(); Waves[n][0] = 1;
		
		To add multiple item wave:
			Waves[n] = new Array(1, 2, 3);
	*/
	
	/*
		ENEMY TYPES
		
			0 - large asteroid (red)
			1 - medium asteroid (blue)
			2 - little asteroid (grey)
			3 - huge asteroid (green)
			4 - large cracked asteroid
			5 - simple UFO
			6 - UFO shard #1
			7 - UFO shard #2
			8 - Enemy bullet #1
			9 - Chaser #1
			10 - Mining enemy
			11 - Miner missile
	*/
	
	// One Small Step
	
	Waves[0] = new Array(1, 1);
	
	// Don't Panic!
	
	Waves[1] = new Array(1, 0);
	Waves[2] = new Array(0, 0);
	Waves[3] = new Array(0, 0, 1);
	Waves[4] = new Array(0, 0, 0);
	
	// Meteor Shower
	
	Waves[5] = new Array(2, 2, 2, 2, 2);
	Waves[6] = new Array(1, 1, 1, 2, 2);
	Waves[7] = new Array(2, 2, 2, 2, 2, 2);
	Waves[8] = new Array(0, 2, 2, 2, 2, 2);
	Waves[9] = new Array(0, 0, 0, 1, 1, 2);
	Waves[10] = new Array(0, 0, 0, 0, 0);
	Waves[11] = new Array(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
	
	// Close Encounters
	
	Waves[12] = new Array(1, 5);
	Waves[13] = new Array(1, 1, 1, 5);
	Waves[14] = new Array(0, 0, 5);
	Waves[15] = new Array(8, 8, 8, 8, 1, 1, 2, 2, 2);
	Waves[16] = new Array(5, 5);
	Waves[17] = new Array(5, 5, 0, 0, 0);
	Waves[18] = new Array(5, 5, 8, 8, 8, 0, 0, 1, 1, 1, 1);
	
	// Comets
	
	Waves[19] = new Array(2, 2, 2);
	Waves[20] = new Array(1, 1);
	Waves[21] = new Array(); Waves[21][0] = 0;
	Waves[22] = new Array(); Waves[22][0] = 3;
	Waves[23] = new Array(3, 0);
	Waves[24] = new Array(0, 3, 8, 8, 8);
	Waves[25] = new Array(3, 5);
	Waves[26] = new Array(3, 5, 1, 1, 1, 1);
	Waves[27] = new Array(3, 5, 5);
	Waves[28] = new Array(3, 3);
	Waves[29] = new Array(3, 3, 8, 8, 8, 8);
	Waves[30] = new Array(3, 0, 0, 0, 0);
	Waves[31] = new Array(3, 3, 3);
	Waves[32] = new Array(3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2);
	Waves[33] = new Array(3, 3, 3, 3);
	
	// Quarry
	
	Waves[34] = new Array(11, 11, 11);
	Waves[35] = new Array(3, 11, 11, 11, 11, 11, 11);
	Waves[36] = new Array(2, 2, 2, 2, 2, 10);
	Waves[37] = new Array(10, 0);
	Waves[38] = new Array(10, 0, 0);
	Waves[39] = new Array(10, 3);
	Waves[40] = new Array(10, 10, 3);
	Waves[41] = new Array(10, 10, 3, 3);
	Waves[42] = new Array(10, 10, 10, 10, 3);
	
	// Guardians
	
	Waves[43] = new Array(9, 9, 1);
	Waves[44] = new Array(10, 0, 0, 9);
	Waves[45] = new Array(10, 10, 10, 9, 9);
	Waves[46] = new Array(3, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9);
	Waves[47] = new Array(9, 9, 9);
	Waves[48] = new Array(3, 3, 9, 9, 9);
	Waves[49] = new Array(6, 6, 7, 7, 7, 9, 9, 9);
	Waves[50] = new Array(8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9);
	Waves[51] = new Array(10, 10, 0, 0, 0, 9, 9, 9);
	Waves[52] = new Array(9, 9, 5);
	Waves[53] = new Array(9, 9, 5, 4, 4);
	Waves[54] = new Array(9, 9, 9, 5, 5);
	Waves[55] = new Array(9, 9, 9, 9, 9, 9);
	
	// The Waste
	
	Waves[56] = new Array(1, 1, 2, 2, 2, 2, 2, 2, 2, 2);
	Waves[57] = new Array(4, 4, 4);
	Waves[58] = new Array(2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4);
	Waves[59] = new Array(4, 8, 8, 8, 8, 8, 8, 8, 8, 8, 11, 11, 11, 11, 11, 11, 11, 11);
	Waves[60] = new Array(4, 4, 4, 4, RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7));
	Waves[61] = new Array(4, 4, 8, 8, 8, 8, 5);
	Waves[62] = new Array(2, 2, 2, 2, 2, 4, 4, 5, RandomNumber(6, 7), RandomNumber(6, 7));
	Waves[63] = new Array(RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7), RandomNumber(6, 7));
	Waves[64] = new Array(3, 5, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11);
	
	// Battlefield
	
	Waves[65] = new Array(8, 8, 8);
	Waves[66] = new Array(8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8);
	Waves[67] = new Array(5, 5, 8, 8, 8);
	Waves[68] = new Array(8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8);
	Waves[69] = new Array(8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9);
	Waves[70] = new Array(5, 5, 5, 5, 5);
	Waves[71] = new Array(11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11);
	Waves[72] = new Array(9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9);
	Waves[73] = new Array(11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11);
	
	WaveCount = Waves.length;
	
}

function MakeRandomWave():void
{
	var RN = RandomNumber(RandomNumber(1, 2), RandomNumber(2, 15));
	Waves[WaveCount] = new Array();
	for(var iWave:int = 0; iWave < RN; iWave++)
	{
		Waves[WaveCount].push(RandomNumber(0, (EnemyModesCount - 1)));
	}
	WaveCount = Waves.length;
}

function SetUpWave(wave:Number)
{
	AtWave = wave;
	
	var ThisWaveCount = Waves[wave].length;
	for(var iWave:int = 0; iWave < ThisWaveCount; iWave++)
	{
		var emode = Waves[wave][iWave];
		CreateEnemies(emode, 1);
	}
	
	SetWaveText(wave);
}

function SetWaveText(wave:Number)
{
	switch(wave)
	{
		case 0:
		{
			wavetext.wave.text = "One Small Step";
			break;
		}
		case 1:
		{
			wavetext.wave.text = "Don't Panic!";
			break;
		}
		case 5:
		{
			wavetext.wave.text = "Meteor Shower";
			break;
		}
		case 12:
		{
			wavetext.wave.text = "Close Encounters";
			break;
		}
		case 19:
		{
			wavetext.wave.text = "Comets";
			break;
		}
		case 34:
		{
			wavetext.wave.text = "Quarry";
			break;
		}
		case 43:
		{
			wavetext.wave.text = "Guardians";
			break;
		}
		case 56:
		{
			wavetext.wave.text = "The Waste";
			break;
		}
		case 65:
		{
			wavetext.wave.text = "Battlefield";
			break;
		}
		case 74:
		{
			wavetext.wave.text = "Unchartered Skies";
			break;
		}
		default:
		{
			break;
		}
	}
}

function N50(clip:MovieClip):void
{
	clip.visible = false;
	clip.x = -50;
	clip.y = -50;
}

function Centre(clip:MovieClip):void
{
	clip.x = stage.stageWidth / 2;
	clip.y = stage.stageHeight / 2;
}

function BringToFront(clip:MovieClip):void
{
	clip.parent.setChildIndex(clip, clip.parent.numChildren - 1);
}

function PlaceRandomSide(clip:MovieClip)
{
	switch(RandomNumber(1, 4))
	{
		case 1:
		{
			clip.x = 0;
			clip.y = RandomNumber(0, stage.stageHeight);
			break;
		}
		case 2:
		{
			clip.x = stage.stageWidth;
			clip.y = RandomNumber(0, stage.stageHeight);
			break;
		}
		case 3:
		{
			clip.y = 0;
			clip.x = RandomNumber(0, stage.stageWidth);
			break;
		}
		case 4:
		{
			clip.y = stage.stageHeight;
			clip.x = RandomNumber(0, stage.stageWidth);
			break;
		}
		default:
		{
			clip.y = 0;
			clip.x = RandomNumber(0, stage.stageWidth);
			break;
		}
	}
}

function UpdateScore(ascore:Number = 0):void
{
	if((Lives >= 1) || (ActiveBulletCount >= 1))
	{
		GameScore += ascore;
		scoretext.score.text = GameScore;
		
		if(Lives >= 1)
		{
			LivesCounter += ascore;
			if(LivesCounter >= 50000)
			{
				LivesCounter -= 50000;
				if(Lives < 10)
				{
					Lives++;
					livestext.lives.text = Lives;
				}
			}
		}
	}
}

function DegreesToRadians(degrees:Number):Number
{
	return degrees * Math.PI / 180;
}

function RandomNumber(low:Number, high:Number):Number
{
	return (Math.floor(Math.random() * (1 + high - low)) + low);
}

function RandomBoolean():Boolean
{
	var rb = ((RandomNumber(1, 2) == 1) ? true : false);
	return rb;
}

function CurrentSpeed(VX:Number, VY:Number):Number
{
	return Math.sqrt((VX * VX) + (VY * VY));
}

function MidPoint(xy1:Number, xy2:Number):Number
{
	return (xy1 + ((xy2 - xy1) / 2));
}

function SideBreach(X:Number, Y:Number):int
{
	if(X > stage.stageWidth)
	{
		return 1;
	}
	else if(X < 0)
	{
		return 2;
	}
	else if(Y > stage.stageHeight)
	{
		return 3;
	}
	else if(Y < 0)
	{
		return 4;
	}
	else
	{
		return 0;
	}
}

function SideScroll(clip:MovieClip, S:int):void
{
	if(S > 0)
	{
		switch(S)
		{
			case 1:
			{
				clip.x = 0;
				break;
			}
			case 2:
			{
				clip.x = stage.stageWidth;
				break;
			}
			case 3:
			{
				clip.y = 0;
				break;
			}
			case 4:
			{
				clip.y = stage.stageHeight;
				break;
			}
			default:
			{
				break;
			}
		}
	}
}

function Collision(clip1:MovieClip, clip2:MovieClip):Boolean
{
	var collide = false;
	if(Math.abs(clip1.x - clip2.x) < clip1.width + clip2.width)
	{
		if(Math.abs(clip1.y - clip2.y) < clip1.height + clip2.height)
		{
			collide = true;
		}
	}
	return collide;
}

function RotatePlane():void
{
	(PlaneRotateSpeed = ((PlaneForward) ? PlaneRotateSpeedForward : PlaneRotateSpeedLimit));
	if(!(RotateRight && RotateLeft))
	{
		if(RotateRight)
		{
			plane.rotation += PlaneRotateSpeed;
		}
		else if(RotateLeft)
		{
			plane.rotation -= PlaneRotateSpeed;
		}
	}
}

function MovePlane():void
{
	var PlaneCurrentSpeed:Number;
	
	if(PlaneForward)
	{
		PlaneCurrentSpeed = CurrentSpeed(PlaneVX, PlaneVY);
		if(PlaneCurrentSpeed > PlaneLimitTemp)
		{
			PlaneVX *= PlaneLimitTemp / PlaneCurrentSpeed;
			PlaneVY *= PlaneLimitTemp / PlaneCurrentSpeed;
		}
		PlaneVY += Math.sin(DegreesToRadians(plane.rotation)) * PlaneForwardSpeed;
		PlaneVX += Math.cos(DegreesToRadians(plane.rotation)) * PlaneForwardSpeed;
	}
	else
	{
		PlaneVX *= PlaneFriction;
		PlaneVY *= PlaneFriction;
		PlaneCurrentSpeed = CurrentSpeed(PlaneVX, PlaneVY);
		if(PlaneCurrentSpeed < 1)
		{
			PlaneVX = 0;
			PlaneVY = 0;
		}
	}
	
	if(Momentum && !PlaneForward)
	{
		if(CurrentSpeed(PlaneVX, PlaneVY) > (PlaneLimitTemp / 2))
		{
			PlaneVX *= 0.95;
			PlaneVY *= 0.95;
		}
	}
	
	plane.x += PlaneVX; //* TimeSinceLastFrame;
	plane.y += PlaneVY; //* TimeSinceLastFrame;
	
	SideScroll(plane, SideBreach(plane.x, plane.y));
}

function DealWithBullets():void
{
	if(Alive)
	{
		FireBullets();
	}
	
	var nba = 0;
	for(var iBullets:int = 0; iBullets < BulletCount; iBullets++)
	{
		if(BulletsFiring[iBullets])
		{
			Bullets[iBullets].x += BulletsVX[iBullets];
			Bullets[iBullets].y += BulletsVY[iBullets];
			
			if(SideBreach(Bullets[iBullets].x, Bullets[iBullets].y) > 0)
			{
				StopBullet(iBullets);
			}
			
			nba++;
			if(nba >= ActiveBulletCount)
			{
				break;
			}
		}
	}
	
	if(Blam)
	{
		Blam = false;
		Whammy();
	}
}

function Whammy(thedamage:Number = 3, themode:String = "mode2"):void
{
	for(var iWhammy:int = 0; iWhammy < 20; iWhammy++)
	{
		MakeBullet(RandomNumber(-180, 180), thedamage, themode);
	}
}

function MakeBullet(brot:Number = 9999, bdamage:Number = 1, bmode:String = "mode1", bx:Number = 9999, by:Number = 0):void
{
	if(brot == 9999)
	{
		brot = plane.rotation;
	}
	if(bx == 9999)
	{
		bx = plane.x;
		by = plane.y;
	}
	for(var iBullets:int = 0; iBullets < BulletCount; iBullets++)
	{
		if(!BulletsFiring[iBullets])
		{
			BulletsFiring[iBullets] = true;
			ActiveBulletCount++;
			Bullets[iBullets].x = bx;
			Bullets[iBullets].y = by;
			Bullets[iBullets].rotation = brot;
			BulletsVY[iBullets] = Math.sin(DegreesToRadians(brot)) * BulletSpeed;
			BulletsVX[iBullets] = Math.cos(DegreesToRadians(brot)) * BulletSpeed;
			Bullets[iBullets].gotoAndStop(bmode);
			BulletsDamage[iBullets] = bdamage;
			Bullets[iBullets].visible = true;
			break;
		}
	}
}

function FireBullets():void
{
	if(Firing && BulletsEnabled)
	{
		BulletsEnabled = false;
		if(PowerBullets <= 0)
		{
			MakeBullet();
		}
		else
		{
			
			PowerBullets--;
			if(PowerBullets >= 1)
			{
				power.gotoAndStop(PowerBullets);
			}
			
			//MakeBullet(rot, dam, mode, x, y)
			switch(PowerMode)
			{
				case 2:
				{
					MakeBullet(plane.rotation, 3, "mode2");
					break;
				}
				case 3:
				{
					MakeBullet(plane.rotation, 3, "mode2");
					MakeBullet((plane.rotation + 180), 3, "mode2");
					break;
				}
				case 4:
				{
					MakeBullet(plane.rotation, 3, "mode2");
					MakeBullet((plane.rotation + AngleChange), 3, "mode2");
					MakeBullet((plane.rotation - AngleChange), 3, "mode2");
					break;
				}
				case 5:
				{
					MakeBullet(plane.rotation, 7, "mode3");
					break;
				}
				case 6:
				{
					MakeBullet(plane.rotation, 3, "mode2");
					AngleChange += 20;
					MakeBullet(plane.rotation, 3, "mode2");
					MakeBullet((plane.rotation + AngleChange), 3, "mode2");
					MakeBullet((plane.rotation - AngleChange), 3, "mode2");
					/*if(AngleDirection)
					{
						MakeBullet((plane.rotation + AngleChange), 3, "mode2");
					}
					else
					{
						MakeBullet((plane.rotation - AngleChange), 3, "mode2");
					}*/
					break;
				}
				case 7:
				{
					MakeBullet(plane.rotation, 3, "mode2");
					for(var iEnemies:int = 0; iEnemies < EnemyCount; iEnemies++)
					{
						if(EnemiesActive[iEnemies])
						{
							var eX:Number = Enemies[iEnemies].x;
							var eY:Number = Enemies[iEnemies].y;
							eX += EnemiesVX[iEnemies] * EnemiesSpeed[iEnemies];
							eY += EnemiesVY[iEnemies] * EnemiesSpeed[iEnemies];
							var diffX = eX - plane.x;
							var diffY = eY - plane.y;
							var BRotation = (Math.atan2(diffY, diffX)) * (180 / Math.PI);
							MakeBullet(BRotation, 3, "mode2");
							break;
						}
					}
					break;
				}
				case 8:
				{
					MakeBullet(plane.rotation, 3, "mode2");
					AngleChange++;
					if(AngleChange >= 7)
					{
						AngleChange = 0;
						Blam = true;
					}
					break;
				}
				case 9:
				{
					AngleChange++;
					if(AngleChange >= 4)
					{
						AngleChange = 0;
						MakeBullet(plane.rotation, 7, "mode3");
					}
					else
					{
						MakeBullet(plane.rotation, 3, "mode2");
					}
					break;
				}
				default:
				{
					MakeBullet();
					break;
				}
			}
			
		}
		
		//if(SoundOn)
		//{
		//	SoundShoot.play();
		//}
		
		setTimeout(EnableFiring, BulletsEnabledTiming);
		
	}
}

function EnableFiring():void
{
	BulletsEnabled = true;
}

function DealWithEnemies():void
{
	var nea = 0;
	for(var iEnemies:int = 0; iEnemies < EnemyCount; iEnemies++)
	{
		if(EnemiesActive[iEnemies])
		{
			MoveEnemy(iEnemies);
			CheckBulletCollisions(iEnemies);
			
			if(Enemies[iEnemies].hit.hitTestObject(plane.hit))
			{
				BouncePlane(Enemies[iEnemies].x, Enemies[iEnemies].y, EnemiesVX[iEnemies], EnemiesVY[iEnemies]);
				ShootEnemy(iEnemies, 1);
				DepleteHealth();
			}
			
			if(!EnemyModesMovementTypical[EnemiesMode[iEnemies]])
			{
				switch(EnemiesMode[iEnemies])
				{
					case 5: // UFO
					{
						if(RandomNumber(1, 50) == 23)
						{
							CreateEnemies(8, 1, Enemies[iEnemies].x, Enemies[iEnemies].y);
						}
						break;
					}
					case 10: // miner
					{
						var TargetExists = false;
						var nea2 = 0;
						for(var ie:int = 0; ie < EnemyCount; ie++)
						{
							if(EnemiesActive[ie])
							{
								if(EnemiesMode[ie] == 2 /*little asteroid*/)
								{
									if(Enemies[iEnemies].hit.hitTestObject(Enemies[ie].hit))
									{
										KillEnemy(ie, false, false, false);
									}
								}
								else
								{
									switch(EnemiesMode[ie])
									{
										case 0:
										case 1:
										case 3:
										case 4:
										{
											TargetExists = true;
											break;
										}
										default:
										{
											break;
										}
									}
								}
								
								nea2++;
								if(nea2 >= ActiveEnemyCount)
								{
									break;
								}
							}
						}
						if(TargetExists)
						{
							if(RandomNumber(0, 100) == 23)
							{
								CreateEnemies(11, 1, Enemies[iEnemies].x, Enemies[iEnemies].y);
							}
						}
						break;
					}
					case 11: // miner bullet
					{
						var finished11 = false;
						var nea2 = 0;
						for(var ie:int = 0; ie < EnemyCount; ie++)
						{
							if(EnemiesActive[ie])
							{
								switch(EnemiesMode[ie])
								{
									case 0:
									case 1:
									case 3:
									case 4:
									{
										if(Enemies[ie].hitTestPoint(Enemies[iEnemies].x, Enemies[iEnemies].y, true))
										{
											KillEnemy(iEnemies, true, false, false);
											switch(EnemiesMode[ie])
											{
												case 0:
												{
													if(RandomNumber(1, 5) == 3)
													{
														KillEnemy(ie, true, false);
													}
													break;
												}
												case 1:
												{
													if(RandomNumber(1, 2) == 2)
													{
														KillEnemy(ie, true, false);
													}
													break;
												}
												case 3:
												{
													if(RandomNumber(1, 7) == 3)
													{
														KillEnemy(ie, true, false);
													}
													break;
												}
												case 4:
												{
													if(RandomNumber(1, 5) == 3)
													{
														KillEnemy(ie, true, false);
													}
													break;
												}
												default:
												{
													break;
												}
											}
											finished11 = true;
										}
										break;
									}
									default:
									{
										break;
									}
								}
								
								if(finished11)
								{
									break;
								}
								
								nea2++;
								if(nea2 >= ActiveEnemyCount)
								{
									break;
								}
							}
						}
						break;
					}
					default:
					{
						break;
					}
				}
			}
			
			nea++;
			if(nea >= ActiveEnemyCount)
			{
				break;
			}
		}
	}
}

function BouncePlane(otherX:Number, otherY:Number, otherVX:Number, otherVY:Number):void
{
	if(BounceEnabled && Alive)
	{
		BounceEnabled = false;
		var MidX = MidPoint(MidPoint(otherX, plane.x), plane.x);
		var MidY = MidPoint(MidPoint(otherY, plane.y), plane.y);
		Explosion(MidX, MidY, 15);
		
		var DX = plane.x - otherX;
		var DY = plane.y - otherY;
		var Dist:Number = Math.sqrt(otherX * otherX + otherY * otherY);
		var Mag:Number = Math.sqrt(otherVX * otherVX + otherVY * otherVY);
		
		PlaneVX = ((Mag * DX / Dist) * BounceSpeed) * PlaneFriction;
		PlaneVY = ((Mag * DY / Dist) * BounceSpeed) * PlaneFriction;
		
		if(CurrentSpeed(PlaneVX, PlaneVY) < BounceSpeed)
		{
			PlaneVX *= 6;
			PlaneVY *= 6;
		}
		if(CurrentSpeed(PlaneVX, PlaneVY) < BounceSpeed)
		{
			PlaneVX *= 6;
			PlaneVY *= 6;
		}
		
		var PlaneCurrentSpeed = CurrentSpeed(PlaneVX, PlaneVY);
		if(PlaneCurrentSpeed > PlaneLimitTemp)
		{
			PlaneVX *= PlaneLimitTemp / PlaneCurrentSpeed;
			PlaneVY *= PlaneLimitTemp / PlaneCurrentSpeed;
		}
		
		setTimeout(EnableBounce, 50);
	}
}

function EnableBounce():void
{
	BounceEnabled = true;
}

function DepleteHealth():void
{
	if(Alive)
	{
		Health--;
		
		if(Health > 0)
		{
			health.gotoAndStop(Health);
			if(Health <= 1)
			{
				KillPlane();
			}
		}
	}
}

function KillPlane():void
{
	if(Alive)
	{
		Alive = false;
		
		if(RandomNumber(1, 4) == 2)
		{
			Whammy(3, "mode2");
		}
		else if(RandomNumber(1, 8) == 4)
		{
			Whammy(7, "mode3");
		}
		else
		{
			Whammy(1, "mode1");
		}
		
		N50(plane);
		PlaneVX = 0;
		PlaneVY = 0;
		
		Explosion(plane.x, plane.y, (plane.width / 3));
		
		Lives--;
		livestext.lives.text = Lives;
		
		if(Lives >= 1)
		{
			Centre(safearea);
			
			RespawnAttempts = 0;
			spawn = setTimeout(Respawn, TimeToRespawn);
		}
		//else gameover
	}
}

function Respawn():void
{
	var safe = true;
	for(var iEnemies = 0; iEnemies < EnemyCount; iEnemies++)
	{
		if(safearea.hitTestObject(Enemies[iEnemies]))
		{
			safe = false;
		}
	}
	
	if(safe)
	{
		MakePlane();
	}
	else
	{
		if(RespawnAttempts < 40)
		{
			RespawnAttempts++;
			setTimeout(Respawn, 300);
		}
		else
		{
			MakePlane();
		}
	}
}

function MakePlane():void
{
	N50(safearea);
	Health = StartHealth;
	health.gotoAndStop(Health);
	Centre(plane);
	plane.rotation = -90;
	plane.visible = true;
	Alive = true;
}

function MoveEnemy(ie:Number):void
{
	
	var emode = EnemiesMode[ie];
	
	var TypicalMovement = true;
	var TypicalSides = true;
	var TypicalRotation = true;
	
	switch(emode)
	{
		case 5: // simple UFO
		{
			TypicalMovement = true;
			TypicalSides = true;
			TypicalRotation = false;
			break;
		}
		case 8: // enemy bullet #1
		{
			TypicalMovement = true;
			TypicalSides = false;
			TypicalRotation = true;
			break;
		}
		case 9: // chasing enemy #1
		{
			TypicalMovement = false;
			TypicalSides = true;
			TypicalRotation = false;
			break;
		}
		case 10: // miner
		{
			TypicalMovement = true;
			TypicalSides = true;
			TypicalRotation = false;
			break;
		}
		case 11: // miner bullet
		{
			TypicalMovement = true;
			TypicalSides = false;
			TypicalRotation = false;
			break;
		}
		default:
		{
			break;
		}
	}
	
	if(TypicalRotation)
	{
		RotateEnemy(ie, emode);
	}
	else
	{
		switch(emode)
		{
			case 9:
			{
				if(Alive)
				{
					var diffX = plane.x - Enemies[ie].x;
					var diffY = plane.y - Enemies[ie].y;
					var ETRotation = (Math.atan2(diffY, diffX)) * (180 / Math.PI);
					if(Enemies[ie].rotation < (ETRotation - 5))
					{
						Enemies[ie].rotation += EnemyModesRotationSpeed[emode];
					}
					else if(Enemies[ie].rotation > (ETRotation + 5))
					{
						Enemies[ie].rotation -= EnemyModesRotationSpeed[emode];
					}
				}
				break;
			}
			default:
			{
				//RotateEnemy(ie, emode);
				break;
			}
		}
	}
	
	if(TypicalMovement)
	{
		Enemies[ie].x += EnemiesVX[ie];
		Enemies[ie].y += EnemiesVY[ie];
	}
	else
	{
		switch(emode)
		{
			case 9:
			{
				if(RandomNumber(1, 20) == 2)
				{
					//below, or SetDirection(1, ie, Enemies[ie].rotation);
					var EnemyCurrentSpeed = CurrentSpeed(EnemiesVX[ie], EnemiesVY[ie]);
					if(EnemyCurrentSpeed > EnemyModesSpeedLimit[emode])
					{
						var timesby = RandomNumber(RandomNumber(1, 3), 4);
						EnemiesVY[ie] *= (EnemyModesSpeedLimit[emode] / EnemyCurrentSpeed) * timesby;
						EnemiesVX[ie] *= (EnemyModesSpeedLimit[emode] / EnemyCurrentSpeed) * timesby;
					}
					EnemiesVY[ie] += Math.sin(DegreesToRadians(Enemies[ie].rotation)) * EnemiesSpeed[ie];
					EnemiesVX[ie] += Math.cos(DegreesToRadians(Enemies[ie].rotation)) * EnemiesSpeed[ie];
					//SetDirection(1, ie, Enemies[ie].rotation);
				}
				else
				{
					if(CurrentSpeed(EnemiesVX[ie], EnemiesVY[ie]) > (EnemyModesSpeedLimit[emode] / 1.01))
					{
						EnemiesVX[ie] *= 0.95;
						EnemiesVY[ie] *= 0.95;
					}
				}
				Enemies[ie].x += EnemiesVX[ie];
				Enemies[ie].y += EnemiesVY[ie];
				break;
			}
			default:
			{
				//Enemies[ie].x += EnemiesVX[ie];
				//Enemies[ie].y += EnemiesVY[ie];
				break;
			}
		}
	}
	
	if(TypicalSides)
	{
		SideScroll(Enemies[ie], SideBreach(Enemies[ie].x, Enemies[ie].y));
	}
	else
	{
		if(SideBreach(Enemies[ie].x, Enemies[ie].y) > 0)
		{
			KillEnemy(ie, false, false, false);
		}
	}
	
}

function RotateEnemy(ie:Number, emode:Number):void
{
	if(EnemiesRotationDirection[ie])
	{
		Enemies[ie].rotation += EnemyModesRotationSpeed[emode];
	}
	else
	{
		Enemies[ie].rotation -= EnemyModesRotationSpeed[emode];
	}
}

function CheckBulletCollisions(ie:Number):void
{
	var nba = 0;
	for(var iBullets:int = 0; iBullets < BulletCount; iBullets++)
	{
		if(BulletsFiring[iBullets])
		{
			//implement better hittest
			if(Enemies[ie].hitTestPoint(Bullets[iBullets].x, Bullets[iBullets].y, true))
			{
				Explosion(Bullets[iBullets].x, Bullets[iBullets].y, Bullets[iBullets].width); //implement this function
				ShootEnemy(ie, BulletsDamage[iBullets]);
				StopBullet(iBullets);
			}
			nba++;
			if(nba >= ActiveBulletCount)
			{
				break;
			}
		}
	}
}

function StopBullet(bullet:Number):void
{
	N50(Bullets[bullet]);
	BulletsVX[bullet] = 0;
	BulletsVY[bullet] = 0;
	BulletsFiring[bullet] = false;
	ActiveBulletCount--;
}

function Explosion(atX:Number, atY:Number, atSize:Number):void
{
	//var atHeight = atWidth;
	
	for(var iSplodes:int = 1; iSplodes < SplodeLimit; iSplodes++)
	{
		if(!SplodesActive[iSplodes])
		{
			SplodesActive[iSplodes] = true;
			Splodes[iSplodes].x = atX;
			Splodes[iSplodes].y = atY;
			Splodes[iSplodes].width = atSize;
			Splodes[iSplodes].height = atSize;
			//BringToFront(Splodes[iSplodes]);
			Splodes[iSplodes].gotoAndPlay(2);
			setTimeout(DeactivateSplode, 200, iSplodes);
			break;
		}
	}
}

function DeactivateSplode(iSplode:Number):void
{
	Splodes[iSplode].gotoAndStop(1);
	SplodesActive[iSplode] = false;
}

function ShootEnemy(enemy:Number, damage:Number):void
{
	if(EnemiesActive[enemy])
	{
		EnemiesHealth[enemy] -= damage;
		
		if(EnemiesHealth[enemy] <= 0)
		{
			KillEnemy(enemy);
		}
	}
}

function KillEnemy(enemy:Number, explode:Boolean = true, givepoints:Boolean = true, givegem:Boolean = true):void
{
	if(EnemiesActive[enemy])
	{
		var DivideWidthBy = 4;
		if(EnemiesMode[enemy] == 3)
		{
			DivideWidthBy = 7;
		}
		
		if(explode)
		{
			Explosion(Enemies[enemy].x, Enemies[enemy].y, (Enemies[enemy].width / DivideWidthBy));
		}
		
		var currentMode = EnemiesMode[enemy];
		
		if(givepoints)
		{
			UpdateScore(EnemyModesScoreReward[currentMode]);
		}
		
		var currentX = Enemies[enemy].x;
		var currentY = Enemies[enemy].y;
		
		
		StopEnemy(enemy);
		
		//CreateEnemies(mode, count, x, y)
		switch(currentMode)
		{
			case 0:
			{
				CreateEnemies(1, 2, currentX, currentY);
				break;
			}
			case 1:
			{
				CreateEnemies(2, 2, currentX, currentY);
				break;
			}
			case 3:
			{
				for(var i4:int = 0; i4 < 3; i4++)
				{
					
					switch(RandomNumber(1, 4))
					{
						case 1:
						{
							CreateEnemies(0, 1, currentX, currentY);
							break;
						}
						case 2:
						{
							CreateEnemies(1, 2, currentX, currentY);
							break;
						}
						case 3:
						{
							CreateEnemies(2, 4, currentX, currentY);
							break;
						}
						case 4:
						{
							CreateEnemies(4, 1, currentX, currentY);
							break;
						}
						default:
						{
							CreateEnemies(1, 2, currentX, currentY);
							break;
						}
					}
					
				}
				break;
			}
			case 4:
			{
				CreateEnemies(2, 7, currentX, currentY);
				break;
			}
			case 5:
			{
				CreateEnemies(6, 1, currentX, currentY);
				CreateEnemies(7, 1, currentX, currentY);
				break;
			}
			case 10:
			{
				CreateEnemies(2, RandomNumber(3, 7), currentX, currentY);
				break;
			}
			default:
			{
				break;
			}
		}
		
		if(givegem)
		{
			MaybeGem(currentMode, currentX, currentY);
		}
		
		if(ActiveEnemyCount <= 0)
		{
			setTimeout(StartNextWave, TimeBetweenWaves);
		}
	}
}

function StartNextWave():void
{
	AtWave++;
	
	if(AtWave <= (WaveCount - 1))
	{
		SetUpWave(AtWave)
	}
	else
	{
		MakeRandomWave();
		SetUpWave(AtWave);
	}
}

function StopEnemy(enemy:Number):void
{
	EnemiesActive[enemy] = false;
	N50(Enemies[enemy]);
	EnemiesSpeed[enemy] = 0;
	EnemiesVX[enemy] = 0;
	EnemiesVY[enemy] = 0;
	ActiveEnemyCount--;
}

function CreateEnemies(emode:Number, count:Number, atx:Number = 9999, aty:Number = 0):void
{
	for(var ic:int = 0; ic < count; ic++)
	{
		for(var iEnemies:int = 0; iEnemies < EnemyCount; iEnemies++)
		{
			if(!EnemiesActive[iEnemies])
			{
				EnemiesActive[iEnemies] = true;
				EnemiesMode[iEnemies] = emode;
				EnemiesHealth[iEnemies] = EnemyModesHealth[emode]
				Enemies[iEnemies].gotoAndStop(emode + 1);
				EnemiesRotationDirection[iEnemies] = RandomBoolean();
				
				if(atx == 9999)
				{
					PlaceRandomSide(Enemies[iEnemies]);
				}
				else
				{
					Enemies[iEnemies].x = atx;
					Enemies[iEnemies].y = aty;
				}
				
				if(EnemyModesMovementTypical[emode])
				{
					Enemies[iEnemies].rotation = RandomNumber(-180, 180);
				}
				else
				{
					switch(emode)
					{
						case 9:
						{
							Enemies[iEnemies].rotation = RandomNumber(-180, 180);
							break;
						}
						default:
						{
							Enemies[iEnemies].rotation = 0;
							break;
						}
					}
				}
				
				
				EnemiesSpeed[iEnemies] = EnemyModesSpeedLimit[emode];
				
				if(EnemyModesMovementTypical[emode])
				{
					SetDirection(1, iEnemies, Enemies[iEnemies].rotation);
				}
				else
				{
					switch(emode)
					{
						case 8:
						{
							var BR = 0;
							if(Alive)
							{
								var diffX = plane.x - Enemies[iEnemies].x;
								var diffY = plane.y - Enemies[iEnemies].y;
								BR = (Math.atan2(diffY, diffX)) * (180 / Math.PI);
							}
							else
							{
								BR = RandomNumber(-180, 180);
							}
							SetDirection(1, iEnemies, BR);
							break;
						}
						case 11:
						{
							var BR = 0;
							var TARGET_ACQUIRED = false;
							var nae = 0;
							for(var ie = 0; ie < EnemyCount; ie++)
							{
								if(EnemiesActive[ie])
								{
									switch(EnemiesMode[ie])
									{
										case 0:
										case 1:
										case 3:
										case 4:
										{
											var eX:Number = Enemies[ie].x;
											var eY:Number = Enemies[ie].y;
											eX += EnemiesVX[ie] * (EnemiesSpeed[ie] * 2);
											eY += EnemiesVY[ie] * (EnemiesSpeed[ie] * 2);
											var diffX = eX - Enemies[iEnemies].x;
											var diffY = eY - Enemies[iEnemies].y;
											BR = (Math.atan2(diffY, diffX)) * (180 / Math.PI);
											TARGET_ACQUIRED = true;
											break;
										}
										default:
										{
											break;
										}
									}
									
									if(TARGET_ACQUIRED)
									{
										break;
									}
									
									nae++;
									if(nae > ActiveEnemyCount)
									{
										break;
									}
								}
							}
							
							if(!TARGET_ACQUIRED)
							{
								BR = RandomNumber(-180, 180);
							}
							
							Enemies[iEnemies].rotation = BR;
							SetDirection(1, iEnemies, Enemies[iEnemies].rotation);
							break;
						}
						default:
						{
							var RR = RandomNumber(-180, 180);
							SetDirection(1, iEnemies, RR);
							break;
						}
					}
					
				}
				
				Enemies[iEnemies].visible = true;
				ActiveEnemyCount++;
				break;
			}
		}
	}
}

function MaybeGem(Mode:Number, atX:Number, atY:Number):void
{
	/*
		To add a new gem:
			Internal frame name: mode[n]
			Add likeliness here - MaybeGem()
			Add effect in CaughtGem()
			If a powermode gem, add to FireBullets()
	*/
	
	if((RandomNumber(1, EnemyModesGemOdds[Mode]) == 1) ||
				(RandomNumber(1, Frustration) == 1))
	{
		Frustration = FrustrationStart;
		
		var GemMode = 1;
		
		var gs = RandomNumber(1, 9);
		
		if(IsBetween(gs, 1, 3))
		{
			GemMode = 1;
		}
		else if(IsBetween(gs, 6, 7))
		{
			GemMode = 3;
		}
		else
		{
			GemMode = RandomNumber(1, GemModeCount);
		}
		
		//GemMode = 6; //fixer - comment out
		
		MakeGem(GemMode, atX, atY);
		
	}
	else
	{
		Frustration--;
	}
}

function IsBetween(nb:Number, low:Number, high:Number):Boolean
{
	return ((nb >= low && nb <= high) ? true : false);
}

function MakeGem(GemMode:Number, atX:Number, atY:Number):void
{
	if(GemsActiveCount < GemLimit)
	{
		for(var iGems:int = 0; iGems < GemLimit; iGems++)
		{
			if(!GemsActive[iGems])
			{
				GemsActive[iGems] = true;
				GemsActiveCount++;
				GemsMode[iGems] = GemMode;
				var framename = "mode" + GemMode;
				Gems[iGems].gotoAndStop(framename);
				Gems[iGems].x = atX;
				Gems[iGems].y = atY;
				Gems[iGems].rotation = RandomNumber(-180, 180);
				SetDirection(2, iGems, Gems[iGems].rotation);
				GemsRotationDirection[iGems] = RandomBoolean();
				Gems[iGems].visible = true;
				break;
			}
		}
	}
}

function DealWithGems():void
{
	if(GemsActiveCount > 0)
	{
		for(var iGems:int = 0; iGems < GemLimit; iGems++)
		{
			if(GemsActive[iGems])
			{
				Gems[iGems].x += GemsVX[iGems];
				Gems[iGems].y += GemsVY[iGems];
				
				if(GemsRotationDirection[iGems])
				{
					Gems[iGems].rotation += GemRotationSpeed;
				}
				else
				{
					Gems[iGems].rotation -= GemRotationSpeed;
				}
				
				if(plane.hit.hitTestObject(Gems[iGems].hit))
				{
					CaughtGem(iGems);
				}
				else if(SideBreach(Gems[iGems].x, Gems[iGems].y) > 0)
				{
					RemoveGem(iGems);
				}
			}
		}
	}
}

function RemoveGem(iGem:Number):void
{
	GemsActive[iGem] = false;
	GemsActiveCount--;
	N50(Gems[iGem]);
	GemsVY[iGem] = 0;
	GemsVX[iGem] = 0;
}

function CaughtGem(iGem:Number):void
{
	var Mode = GemsMode[iGem];
	RemoveGem(iGem);
	
	if(Mode == 11)
	{
		Mode = RandomNumber(1, GemModeCount);
		Mode = ((Mode == 11) ? RandomNumber(1, GemModeCount) : Mode);
		Mode = ((Mode == 11) ? RandomNumber(1, 10) : Mode);
	}
	
	switch(Mode)
	{
		case 1: // health refill
		{
			if(Health == StartHealth)
			{
				UpdateScore(1000);
			}
			else
			{
				Health = StartHealth;
				health.gotoAndStop(Health);
			}
			break;
		}
		case 2: // +1 life / uberbullets
		{
			if(Lives < 10)
			{
				Lives++;
				livestext.lives.text = Lives;
			}
			else
			{
				SetPowerMode(5);
			}
			break;
		}
		case 3: // better bullet
		{
			SetPowerMode(2);
			break;
		}
		case 4: // backwards firing
		{
			SetPowerMode(3);
			break;
		}
		case 5: // 3 bullets
		{
			SetPowerMode(4);
			AngleChange = RandomNumber(5, 70);
			break;
		}
		case 6: // circling bullet
		{
			SetPowerMode(6);
			AngleChange = 0;
			break;
		}
		case 7: // homer
		{
			AngleDirection = true;
			AngleChange = 0;
			SetPowerMode(7);
			break;
		}
		case 8: // weed
		{
			var nea = 0;
			for(var iEnemies:int = 0; iEnemies < EnemyCount; iEnemies++)
			{
				if(EnemiesActive[iEnemies])
				{
					if(CurrentSpeed(EnemiesVX[iEnemies], EnemiesVY[iEnemies]) > 0.1)
					{
						EnemiesVX[iEnemies] /= 3;
						EnemiesVY[iEnemies] /= 3;
					}
					nea++;
					if(nea >= ActiveEnemyCount)
					{
						break;
					}
				}
			}
			break;
		}
		case 9:
		{
			AngleChange = 0;
			SetPowerMode(8);
			break;
		}
		case 10:
		{
			AngleChange = 0;
			SetPowerMode(9);
			break;
		}
		default:
		{
			break;
		}
	}
	
	UpdateScore(2000);
}

function SetPowerMode(pMode:Number):void
{
	PowerMode = pMode;
	if(PowerBullets > 0)
	{
		Blam = true;
	}
	PowerBullets = PowerBulletsLimit;
	power.gotoAndStop(PowerBullets);
}

function SetDirection(attype:Number, atindex:Number, atrot:Number):void
{
	if(attype == 1) //enemies
	{
		EnemiesVY[atindex] = Math.sin(DegreesToRadians(atrot)) * EnemiesSpeed[atindex];
		EnemiesVX[atindex] = Math.cos(DegreesToRadians(atrot)) * EnemiesSpeed[atindex];
	}
	else if(attype == 2) //gems
	{
		GemsVY[atindex] = Math.sin(DegreesToRadians(atrot)) * GemSpeed;
		GemsVX[atindex] = Math.cos(DegreesToRadians(atrot)) * GemSpeed;
	}
}

function GameLoop(event:Event):void
{	
	if(!GamePaused)
	{
		if(Alive)
		{
			RotatePlane();
			MovePlane();
		}
		DealWithBullets();
		DealWithEnemies();
		DealWithGems();
	}
}