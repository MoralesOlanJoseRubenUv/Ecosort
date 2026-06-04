using Godot;
using System;
using Godot.Collections;

public partial class LoginMenu : Control
{
	[Export] private LineEdit _usernameInput;
	[Export] private LineEdit _passwordInput;
	[Export] private Label _feedbackLabel;
	
	public override void _Ready()
	{
		// Llamamos al Autoload de la música usando C#
		GetNode("/root/MusicaFondo").Call("reproducir_login");
		GetNode("/root/MenuAjustes").Call("mostrar_boton");
	}

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
			// 3. Cargar datos al Manager
			PlayerDataManager.CurrentUsername = username;
			GetNode("/root/Global").Set("id_sesion", username);
			PlayerDataManager.CurrentPassword = password; // Lo guardamos en memoria para el auto-guardado
			PlayerDataManager.TotalScore = (int)data["total_score"];
			PlayerDataManager.CurrentLevel = (int)data["current_level"];
			
			// NUEVO: Leemos el progreso máximo desbloqueado (con seguro anti-crasheos para cuentas viejas)
			if (data.ContainsKey("max_unlocked_level"))
			{
				PlayerDataManager.MaxUnlockedLevel = (int)data["max_unlocked_level"];
			}
			else
			{
				PlayerDataManager.MaxUnlockedLevel = 1;
			}
			
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

	public void _on_btn_exit_pressed() 
	{
		GetTree().Quit();
	}
}
