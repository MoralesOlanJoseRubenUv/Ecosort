using Godot;
using System;

public partial class WinMenu : CanvasLayer
{
	[Export] private string _menuScenePath = "res://Scenes/LevelSelectionMenu.tscn";

	public override void _Ready()
	{
		Hide();
		// Escuchamos la señal de victoria de global.gd[cite: 27]
		var global = GetNode("/root/Global");
		global.Connect("juego_ganado", Callable.From(OnWinTriggered));
	}

	private void OnWinTriggered()
	{
		Show();
		GetTree().Paused = true; // Pausamos los objetos que caen[cite: 8]
	}

	public void _on_btn_menu_pressed()
	{
		GetTree().Paused = false;
		// Limpiamos puntos para la siguiente partida[cite: 27]
		var global = GetNode("/root/Global");
		global.Set("puntos", 0);
		
		GetTree().ChangeSceneToFile(_menuScenePath);
	}
}
