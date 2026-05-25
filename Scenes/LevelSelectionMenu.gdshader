shader_type canvas_item;

// Estas variables aparecerán en el Inspector para que las modifiques sin tocar el código
uniform float velocidad_viento = 1.0;
uniform float frecuencia_olas = 10.0;
uniform float fuerza_distorsion = 0.005; 

void fragment() {
    // Tomamos las coordenadas originales de la imagen
    vec2 coordenadas = UV;
    
    // Aplicamos una fórmula matemática de onda (Seno) para deformar el eje X
    coordenadas.x += sin(coordenadas.y * frecuencia_olas + TIME * velocidad_viento) * fuerza_distorsion;
    
    // Le decimos a Godot que dibuje la imagen con las nuevas coordenadas distorsionadas
    COLOR = texture(TEXTURE, coordenadas);
}