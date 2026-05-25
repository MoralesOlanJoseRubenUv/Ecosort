using Godot;
using System;

public partial class LevelSelectionMenu : Control
{
	// Cambia esta ruta por la ruta real de tu escena principal del juego Ecosort
	private string _gameScenePath = "res://Scenes/mundo.tscn"; 

	// NIVEL 1 - FÁCIL
// Cambia los nombres para que coincidan con la escena .tscn
public void _on_btn_level_1_pressed()
{
	var global = GetNode("/root/Global");
	// 1. Actualizamos el Global de GDScript para el juego actual
	global.Set("falling_speed", 150.0f);
	global.Set("vidas", 5);
	global.Set("include_second_use", false);
	
	// 2. ¡CRÍTICO! Actualizamos el Manager de C# para que el 'Retry' lo sepa
	PlayerDataManager.MaxLives = 5; 
	PlayerDataManager.FallingSpeed = 150.0f;
	PlayerDataManager.IncludeSecondUse = false;

	GetTree().ChangeSceneToFile("res://Scenes/mundo.tscn");
}

public void _on_btn_level_2_pressed()
{
	var global = GetNode("/root/Global");
	global.Set("falling_speed", 250.0f);
	global.Set("vidas", 3);
	global.Set("include_second_use", false);
	
	PlayerDataManager.MaxLives = 3;
	PlayerDataManager.FallingSpeed = 250.0f;
	PlayerDataManager.IncludeSecondUse = false;

	GetTree().ChangeSceneToFile("res://Scenes/mundo.tscn");
}

public void _on_btn_level_3_pressed()
{
	var global = GetNode("/root/Global");
	global.Set("falling_speed", 400.0f);
	global.Set("vidas", 1);
	global.Set("include_second_use", true);
	
	PlayerDataManager.MaxLives = 1;
	PlayerDataManager.FallingSpeed = 400.0f;
	PlayerDataManager.IncludeSecondUse = true;

	GetTree().ChangeSceneToFile("res://Scenes/mundo.tscn");
}

	public void _on_btn_logout_pressed() // Antes era _on_logout_button_pressed
{
	PlayerDataManager.CurrentUsername = "";
	PlayerDataManager.TotalScore = 0;
	PlayerDataManager.CurrentLevel = 1;

	GetTree().ChangeSceneToFile("res://LoginMenu.tscn");
}
}
