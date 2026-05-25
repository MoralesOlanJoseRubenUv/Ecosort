using Godot;
using System;
using Godot.Collections;

public partial class LoginMenu : Control
{
	[Export] private LineEdit _usernameInput;
	[Export] private LineEdit _passwordInput;
	[Export] private Label _feedbackLabel;

	public void _on_login_button_pressed()
	{
		string username = _usernameInput.Text;
		string password = _passwordInput.Text;
		string path = $"user://{username}_save.json";

		// 1. ¿Existe el usuario?
		if (!FileAccess.FileExists(path))
		{
			_feedbackLabel.Text = "Usuario no encontrado.";
			return;
		}

		// 2. Leer archivo y verificar contraseña
		using var file = FileAccess.Open(path, FileAccess.ModeFlags.Read);
		var data = (Dictionary)Json.ParseString(file.GetAsText());

		if (data["password"].ToString() == password)
		{
			// 3. Cargar datos al Manager y entrar
			PlayerDataManager.CurrentUsername = username;
			PlayerDataManager.TotalScore = (int)data["total_score"];
			PlayerDataManager.CurrentLevel = (int)data["current_level"];
			
			GetTree().ChangeSceneToFile("res://Scenes/LevelSelectionMenu.tscn");
		}
		else
		{
			_feedbackLabel.Text = "Contraseña incorrecta.";
		}
	}

	public void _on_go_to_register_pressed()
	{
		GetTree().ChangeSceneToFile("res://menu_registro.tscn");
	}

	// Añade esta función al final de tu clase LoginMenu
public void _on_btn_exit_pressed() // Antes era _on_exit_button_pressed
{
	GetTree().Quit();
}
}
