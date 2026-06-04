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
		// 1. Quitamos la pausa general
		GetTree().Paused = false; 
		
		// 2. Escondemos la tuerca de ajustes si es que estaba abierta
		if (GetNodeOrNull("/root/MenuAjustes") != null)
		{
			GetNode("/root/MenuAjustes").Call("ocultar_boton");
		}
		
		// 3. Reseteo total del Reporte Ambiental en el Autoload Global
		Node global = GetNode("/root/Global");
		global.Set("puntos", 0);
		
		// Determinamos cuántas vidas darle dependiendo del nivel en el que estaba
		int nivelActual = (int)global.Get("nivel_actual");
		int vidasIniciales = 3;
		if (nivelActual == 1) vidasIniciales = 5;
		else if (nivelActual == 3) vidasIniciales = 1;
		
		global.Set("vidas", vidasIniciales);
		global.Set("tiempo_jugado", 0.0f);
		global.Set("basura_procesada", 0);
		global.Set("basura_correcta", 0);
		global.Set("basura_incorrecta", 0);
		global.Set("errores_contaminacion", 0);
		global.Set("errores_reuso", 0);
		global.Set("errores_trampas", 0);
		global.Set("intervenciones_eco", 0);
		global.Set("juego_activo", false); 
		
		// 4. Reiniciamos la escena con el historial impecable
		GetTree().ReloadCurrentScene();
	}

	public void _on_btn_quit_to_menu_pressed()
	{
		GetTree().Paused = false;
		
		// Al ir al menú de niveles, ese menú ya tiene la instrucción de mostrar el botón en su _Ready
		GetTree().ChangeSceneToFile(_menuScenePath);
	}
}
