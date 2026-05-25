using Godot;
using System;

public partial class WinMenu : CanvasLayer
{
	[Export] private string _menuScenePath = "res://Scenes/LevelSelectionMenu.tscn";
	[Export] private string _gameScenePath = "res://Scenes/mundo.tscn";

	private Button _btnSiguienteNivel;

	public override void _Ready()
	{
		Hide();
		_btnSiguienteNivel = GetNode<Button>("VBoxContainer/BtnSiguienteNivel");

		var global = GetNode("/root/Global");
		global.Connect("juego_ganado", Callable.From(OnWinTriggered));
	}

	private void OnWinTriggered()
	{
		Show();
		GetTree().Paused = true; 

		var global = GetNode("/root/Global");
		int nivelActual = (int)global.Get("nivel_actual");
		int totalNiveles = (int)global.Get("total_niveles");

		// 1. Validamos usando tu PlayerDataManager
		if (nivelActual == PlayerDataManager.MaxUnlockedLevel && PlayerDataManager.MaxUnlockedLevel < totalNiveles)
		{
			// Subimos el récord
			PlayerDataManager.MaxUnlockedLevel++;
			
			// Sincronizamos con el GDScript por si acaso
			global.Set("max_nivel_desbloqueado", PlayerDataManager.MaxUnlockedLevel);
			
			// ¡MAGIA! Guardamos en tu archivo JSON
			PlayerDataManager.SaveProgress();
		}

		// 2. Mostrar botón si no es el último nivel
		if (nivelActual < totalNiveles)
		{
			_btnSiguienteNivel.Show();
		}
		else
		{
			_btnSiguienteNivel.Hide(); 
		}
	}

	public void _on_btn_siguiente_nivel_pressed()
	{
		GetTree().Paused = false; 
		var global = GetNode("/root/Global");
		
		int nivelActual = (int)global.Get("nivel_actual");
		int siguienteNivel = nivelActual + 1;
		
		global.Set("nivel_actual", siguienteNivel);
		global.Set("puntos", 0); 

		// Configurar dificultad del siguiente
		if (siguienteNivel == 2)
		{
			global.Set("falling_speed", 250.0f);
			global.Set("vidas", 3);
			global.Set("include_second_use", false);
			
			PlayerDataManager.MaxLives = 3;
			PlayerDataManager.FallingSpeed = 250.0f;
			PlayerDataManager.IncludeSecondUse = false;
		}
		else if (siguienteNivel == 3)
		{
			global.Set("falling_speed", 400.0f);
			global.Set("vidas", 1);
			global.Set("include_second_use", true);
			
			PlayerDataManager.MaxLives = 1;
			PlayerDataManager.FallingSpeed = 400.0f;
			PlayerDataManager.IncludeSecondUse = true;
		}

		GetTree().ChangeSceneToFile(_gameScenePath);
	}

	public void _on_btn_menu_pressed()
	{
		GetTree().Paused = false;
		var global = GetNode("/root/Global");
		global.Set("puntos", 0);
		GetTree().ChangeSceneToFile(_menuScenePath);
	}
}
