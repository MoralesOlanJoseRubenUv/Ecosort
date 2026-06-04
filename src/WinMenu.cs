using Godot;
using System;

public partial class WinMenu : CanvasLayer
{
	[Export] private string _menuScenePath = "res://Scenes/LevelSelectionMenu.tscn";
	// mi nueva ruta obligatoria para el examen
	[Export] private string _triviaScenePath = "res://Scenes/pantalla_victoria.tscn";

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

		// ya no desbloqueo ni guardo nada aqui, eso se hace despues de la trivia
		// solo muestro el boton para que vayan al examen
		_btnSiguienteNivel.Show();
	}

	public void _on_btn_siguiente_nivel_pressed()
	{
		GetTree().Paused = false; 
		var global = GetNode("/root/Global");
		
		// reinicio mis puntos por seguridad
		global.Set("puntos", 0); 

		// los mando a sufrir con el examen
		GetTree().ChangeSceneToFile(_triviaScenePath);
	}

	public void _on_btn_menu_pressed()
	{
		GetTree().Paused = false;
		var global = GetNode("/root/Global");
		global.Set("puntos", 0);
		GetTree().ChangeSceneToFile(_menuScenePath);
	}
}
