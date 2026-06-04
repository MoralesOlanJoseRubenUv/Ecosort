using Godot;
using System;

public partial class LevelSelectionMenu : Control
{
	private string _gameScenePath = "res://Scenes/mundo.tscn"; 
	private Button btnLevel2;
	private Button btnLevel3;

	private bool _isLoading = false;
	private CanvasLayer _pantallaCarga;

	private double _timeElapsed = 0.0;
	private double _minLoadingTime = 3.5; 

	// mis variables para el easter egg
	private string _codigoSecreto = "juanjaro";
	private string _teclasPresionadas = "";
	private double _tiempoEasterEgg = 0.0;
	private bool _escribiendoEasterEgg = false;

	public override void _Ready()
	{
		GetNode("/root/MenuAjustes").Call("mostrar_boton");

		var global = GetNode("/root/Global");

		int globalMax = (int)global.Get("max_nivel_desbloqueado");
		

		if (globalMax > PlayerDataManager.MaxUnlockedLevel)
		{
			PlayerDataManager.MaxUnlockedLevel = globalMax;
			PlayerDataManager.SaveProgress(PlayerDataManager.CurrentPassword);
		}

		else if (PlayerDataManager.MaxUnlockedLevel > globalMax)
		{
			global.Set("max_nivel_desbloqueado", PlayerDataManager.MaxUnlockedLevel);
			globalMax = PlayerDataManager.MaxUnlockedLevel; 
		}
		
		global.Set("trivia_ganada", false);

		btnLevel2 = GetNode<Button>("VBoxContainer/BtnLevel2");
		btnLevel3 = GetNode<Button>("VBoxContainer/BtnLevel3");

		btnLevel2.Hide();
		btnLevel3.Hide();

		int maxDesbloqueado = PlayerDataManager.MaxUnlockedLevel;
		global.Set("max_nivel_desbloqueado", maxDesbloqueado);

		if (maxDesbloqueado >= 2) btnLevel2.Show();
		if (maxDesbloqueado >= 3) btnLevel3.Show();

		GetNode("/root/MusicaFondo").Call("reproducir_selector");
	}

	private void IniciarCargaNivel()
	{
		Callable.From(CargarEscenaVisual).CallDeferred();
	}

	private void CargarEscenaVisual()
	{
		GetNode("/root/MenuAjustes").Call("ocultar_boton");
		
		var escenaCarga = GD.Load<PackedScene>("res://Scenes/pantalla_carga.tscn");
		_pantallaCarga = (CanvasLayer)escenaCarga.Instantiate();
		AddChild(_pantallaCarga);

		ResourceLoader.LoadThreadedRequest(_gameScenePath);
		
		_timeElapsed = 0.0; 
		_isLoading = true;
	}

	public override void _Process(double delta)
	{
		// mi temporizador del easter egg
		if (_escribiendoEasterEgg)
		{
			_tiempoEasterEgg += delta;
			if (_tiempoEasterEgg > 30.0)
			{
				// se acabo el tiempo, reinicio todo
				_teclasPresionadas = "";
				_escribiendoEasterEgg = false;
			}
		}

		if (_isLoading)
		{
			_timeElapsed += delta;

			var progress = new Godot.Collections.Array();
			var status = ResourceLoader.LoadThreadedGetStatus(_gameScenePath, progress);

			if (status == ResourceLoader.ThreadLoadStatus.Loaded && _timeElapsed >= _minLoadingTime)
			{
				_isLoading = false;
				var packedScene = (PackedScene)ResourceLoader.LoadThreadedGet(_gameScenePath);
				GetTree().ChangeSceneToPacked(packedScene);
			}
		}
	}

	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventKey keyEvent && keyEvent.Pressed && !keyEvent.Echo)
		{
			char letra = (char)keyEvent.Unicode;
			
			if (char.IsLetter(letra))
			{
				if (!_escribiendoEasterEgg)
				{
					_escribiendoEasterEgg = true;
					_tiempoEasterEgg = 0.0;
					_teclasPresionadas = "";
				}

				_teclasPresionadas += char.ToLower(letra);
				
				// corto el texto si ya me pase del largo
				if (_teclasPresionadas.Length > _codigoSecreto.Length)
				{
					_teclasPresionadas = _teclasPresionadas.Substring(_teclasPresionadas.Length - _codigoSecreto.Length);
				}

				if (_teclasPresionadas == _codigoSecreto)
				{
					_activar_easter_egg();
				}
			}
		}
	}

	private void _activar_easter_egg()
	{
		PlayerDataManager.MaxUnlockedLevel = 1;
		PlayerDataManager.SaveProgress(PlayerDataManager.CurrentPassword);

		GetNode("/root/Global").Set("max_nivel_desbloqueado", 1);

		btnLevel2.Hide();
		btnLevel3.Hide();

		_teclasPresionadas = "";
		_escribiendoEasterEgg = false;
	}

	public void _on_btn_level_1_pressed()
	{
		var global = GetNode("/root/Global");
		global.Set("nivel_actual", 1);
		global.Set("falling_speed", 150.0f);
		global.Set("vidas", 5);
		global.Set("include_second_use", false);
		
		PlayerDataManager.MaxLives = 5; 
		PlayerDataManager.FallingSpeed = 150.0f;
		PlayerDataManager.IncludeSecondUse = false;

		IniciarCargaNivel(); 
	}

	public void _on_btn_level_2_pressed()
	{
		var global = GetNode("/root/Global");
		global.Set("nivel_actual", 2);
		global.Set("falling_speed", 250.0f);
		global.Set("vidas", 3);
		global.Set("include_second_use", false);
		
		PlayerDataManager.MaxLives = 3;
		PlayerDataManager.FallingSpeed = 250.0f;
		PlayerDataManager.IncludeSecondUse = false;

		IniciarCargaNivel(); 
	}

	public void _on_btn_level_3_pressed()
	{
		var global = GetNode("/root/Global");
		global.Set("nivel_actual", 3);
		global.Set("falling_speed", 400.0f);
		global.Set("vidas", 1);
		global.Set("include_second_use", true);
		
		PlayerDataManager.MaxLives = 1;
		PlayerDataManager.FallingSpeed = 400.0f;
		PlayerDataManager.IncludeSecondUse = true;

		IniciarCargaNivel(); 
	}

	public void _on_btn_logout_pressed() 
	{
		PlayerDataManager.CurrentUsername = "";
		PlayerDataManager.CurrentPassword = ""; 
		PlayerDataManager.TotalScore = 0;
		PlayerDataManager.CurrentLevel = 1;
		PlayerDataManager.MaxUnlockedLevel = 1; 

		var global = GetNode("/root/Global");
		global.Set("max_nivel_desbloqueado", 1);

		GetTree().ChangeSceneToFile("res://LoginMenu.tscn");
	}
}
