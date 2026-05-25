using Godot;
using System;

public partial class LevelSelectionMenu : Control
{
	private string _gameScenePath = "res://Scenes/mundo.tscn"; 
	private Button btnLevel2;
	private Button btnLevel3;

	public override void _Ready()
	{
		btnLevel2 = GetNode<Button>("VBoxContainer/BtnLevel2");
		btnLevel3 = GetNode<Button>("VBoxContainer/BtnLevel3");

		btnLevel2.Hide();
		btnLevel3.Hide();

		// Leemos tu Manager directamente
		int maxDesbloqueado = PlayerDataManager.MaxUnlockedLevel;

		// Sincronizamos con el GDScript
		var global = GetNode("/root/Global");
		global.Set("max_nivel_desbloqueado", maxDesbloqueado);

		if (maxDesbloqueado >= 2) btnLevel2.Show();
		if (maxDesbloqueado >= 3) btnLevel3.Show();
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

		GetTree().ChangeSceneToFile(_gameScenePath);
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

		GetTree().ChangeSceneToFile(_gameScenePath);
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

		GetTree().ChangeSceneToFile(_gameScenePath);
	}

	public void _on_btn_logout_pressed() 
	{
		PlayerDataManager.CurrentUsername = "";
		PlayerDataManager.CurrentPassword = ""; // Limpiamos la caché
		PlayerDataManager.TotalScore = 0;
		PlayerDataManager.CurrentLevel = 1;
		PlayerDataManager.MaxUnlockedLevel = 1; // Reseteamos memoria

		var global = GetNode("/root/Global");
		global.Set("max_nivel_desbloqueado", 1);

		GetTree().ChangeSceneToFile("res://LoginMenu.tscn");
	}
}
