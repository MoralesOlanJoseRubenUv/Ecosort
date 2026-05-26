using Godot;
using System;

public partial class LevelSelectionMenu : Control
{
	private string _gameScenePath = "res://Scenes/mundo.tscn"; 
	private Button btnLevel2;
	private Button btnLevel3;

	// Variables para la carga en segundo plano
	private bool _isLoading = false;
	private CanvasLayer _pantallaCarga;

	// NUEVAS VARIABLES: Controladores del tiempo mínimo en pantalla
	private double _timeElapsed = 0.0;
	private double _minLoadingTime = 3.5; // Tiempo mínimo obligatorio en segundos (ej. 3.5 segundos)

	public override void _Ready()
	{
		btnLevel2 = GetNode<Button>("VBoxContainer/BtnLevel2");
		btnLevel3 = GetNode<Button>("VBoxContainer/BtnLevel3");

		btnLevel2.Hide();
		btnLevel3.Hide();

		int maxDesbloqueado = PlayerDataManager.MaxUnlockedLevel;

		var global = GetNode("/root/Global");
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
		var escenaCarga = GD.Load<PackedScene>("res://Scenes/pantalla_carga.tscn");
		_pantallaCarga = (CanvasLayer)escenaCarga.Instantiate();
		AddChild(_pantallaCarga);

		ResourceLoader.LoadThreadedRequest(_gameScenePath);
		
		_timeElapsed = 0.0; // Reiniciamos el contador al empezar la carga
		_isLoading = true;
	}

	public override void _Process(double delta)
	{
		if (_isLoading)
		{
			// Acumulamos los segundos transcurridos frame por frame
			_timeElapsed += delta;

			var progress = new Godot.Collections.Array();
			var status = ResourceLoader.LoadThreadedGetStatus(_gameScenePath, progress);

			// CONDICIÓN: Cambia de escena SOLO si el motor ya cargó los archivos Y ADEMÁS ya se cumplió el tiempo mínimo
			if (status == ResourceLoader.ThreadLoadStatus.Loaded && _timeElapsed >= _minLoadingTime)
			{
				_isLoading = false;
				var packedScene = (PackedScene)ResourceLoader.LoadThreadedGet(_gameScenePath);
				GetTree().ChangeSceneToPacked(packedScene);
			}
		}
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
