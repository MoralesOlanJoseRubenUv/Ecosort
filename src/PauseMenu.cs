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
    }

    // Funciones para conectar a las señales de los botones
    public void _on_btn_resume_pressed()
    {
        TogglePause(); // Al presionar Continuar, simplemente invertimos la pausa
    }

    public void _on_btn_restart_pressed()
    {
        // Importante: ¡Quitar la pausa antes de reiniciar o la nueva escena nacerá congelada!
        GetTree().Paused = false; 
        GetTree().ReloadCurrentScene();
    }

    public void _on_btn_quit_to_menu_pressed()
    {
        GetTree().Paused = false;
        GetTree().ChangeSceneToFile(_menuScenePath);
    }
}