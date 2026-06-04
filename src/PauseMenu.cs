using Godot;
using System;

public partial class PauseMenu : CanvasLayer
{
	// Ruta al menú de selección de nivel
	private string _menuScenePath = "res://Scenes/LevelSelectionMenu.tscn"; 

	public override void _Ready()
	{
		// El menú de pausa arranca invisible
		Hide();
		
		// --- SEGURO ANTI-BUGS ---
		// Nos aseguramos de que la tuerca esté oculta apenas empiece a jugar
		GetNode("/root/MenuAjustes").Call("ocultar_boton");
	}

	public override void _Process(double delta)
	{
		// Detectamos si el jugador presiona Escape
		if (Input.IsActionJustPressed("pause_game"))
		{
			TogglePause();
		}
	}

	private void TogglePause()
	{
		// Invertimos el estado de pausa actual
		bool newPauseState = !GetTree().Paused;
		GetTree().Paused = newPauseState;
		
		// Mostramos u ocultamos el menú visualmente
		Visible = newPauseState;
		
		// --- NUEVO: Controlar la tuerca de ajustes ---
		if (newPauseState)
		{
			// Si el juego se pausó, mostramos el botón
			GetNode("/root/MenuAjustes").Call("mostrar_boton");
		}
		else
		{
			// Si quitamos la pausa, escondemos el botón
			GetNode("/root/MenuAjustes").Call("ocultar_boton");
		}
	}

	// Funciones para conectar a las señales de los botones
	public void _on_btn_resume_pressed()
	{
		TogglePause(); // Al presionar Continuar, invertimos la pausa y se oculta la tuerca
	}

	public void _on_btn_restart_pressed()
	{
		// Importante: ¡Quitar la pausa antes de reiniciar o la nueva escena nacerá congelada!
		GetTree().Paused = false; 
		
		// Escondemos la tuerca para que el nivel empiece limpio
		GetNode("/root/MenuAjustes").Call("ocultar_boton");
		
		GetTree().ReloadCurrentScene();
	}

	public void _on_btn_quit_to_menu_pressed()
	{
		GetTree().Paused = false;
		
		// Al ir al menú de niveles, ese menú ya tiene la instrucción de mostrar el botón en su _Ready
		GetTree().ChangeSceneToFile(_menuScenePath);
	}
}
