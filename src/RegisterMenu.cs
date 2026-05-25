using Godot;
using System;
using Godot.Collections;

public partial class RegisterMenu : Control
{
	[Export] private LineEdit _usernameInput;
	[Export] private LineEdit _passwordInput;
	[Export] private Label _feedbackLabel;

	private string _levelSelectPath = "res://Scenes/LevelSelectionMenu.tscn";
	private string _loginMenuPath = "res://LoginMenu.tscn";

	public void _on_register_button_pressed()
	{
		string username = _usernameInput.Text.StripEdges();
		string password = _passwordInput.Text.StripEdges();

		// Validamos que los campos no estén vacíos
		if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
		{
			_feedbackLabel.Text = "Por favor, llena todos los campos.";
			return;
		}

		string path = $"user://{username}_save.json";

		// 1. Verificamos si el usuario ya existe
		if (FileAccess.FileExists(path))
		{
			_feedbackLabel.Text = "El usuario ya existe. Intenta con otro.";
			return;
		}

		// 2. Si es nuevo, configuramos los datos iniciales en el Manager
		PlayerDataManager.CurrentUsername = username;
		PlayerDataManager.TotalScore = 0;
		PlayerDataManager.CurrentLevel = 1;
		
		// NUEVO: Nos aseguramos de que empiece en el nivel 1
		PlayerDataManager.MaxUnlockedLevel = 1; 

		// 3. Guardamos físicamente el archivo usando la función del Manager
		PlayerDataManager.SaveProgress(password);

		_feedbackLabel.Text = "¡Registro exitoso! Cargando niveles...";
		
		GetTree().CreateTimer(1.5f).Timeout += () => 
		{
			GetTree().ChangeSceneToFile(_levelSelectPath);
		};
	}

	public void _on_go_to_login_pressed()
	{
		GetTree().ChangeSceneToFile(_loginMenuPath);
	}

	public void _on_btn_exit_pressed() 
	{
		GetTree().Quit();
	}
}
