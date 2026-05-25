using Godot;
using System;

public partial class GameOverMenu : CanvasLayer
{
	// Asegúrate de que esta ruta coincida exactamente con tu carpeta[cite: 8]
	[Export] private string _menuScenePath = "res://Scenes/LevelSelectionMenu.tscn";

	public override void _Ready()
	{
		Hide();
		// Conexión a la señal de Game Over definida en global.gd[cite: 27]
		var global = GetNode("/root/Global");
		global.Connect("game_over", Callable.From(OnGameOverTriggered));
	}

	private void OnGameOverTriggered()
	{
		Show();
		GetTree().Paused = true; // Congelamos el juego[cite: 8]
	}

	public void _on_btn_retry_pressed()
	{
		var global = GetNode("/root/Global");
		
		// 1. Resetear Puntos[cite: 27]
		global.Set("puntos", 0);
		
		// 2. Resetear Vidas según la dificultad guardada en C#
		global.Set("vidas", PlayerDataManager.MaxLives);
		
		// 3. Quitar pausa y reiniciar[cite: 8]
		GetTree().Paused = false;
		GetTree().ReloadCurrentScene();
	}

	public void _on_btn_menu_pressed()
	{
		// 1. MUY IMPORTANTE: Quitar la pausa antes de cambiar de escena[cite: 8]
		GetTree().Paused = false;
		
		// 2. Cambiar a la selección de niveles[cite: 4, 6]
		Error result = GetTree().ChangeSceneToFile(_menuScenePath);
		
		if (result != Error.Ok)
		{
			GD.PrintErr("Error al cargar la escena de menú: " + _menuScenePath);
		}
	}
}
