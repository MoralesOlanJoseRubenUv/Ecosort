#ifndef FALLING_OBJECT_H
#define FALLING_OBJECT_H

#include <godot_cpp/classes/area2d.hpp>
#include <godot_cpp/classes/viewport.hpp>
#include <godot_cpp/classes/input_event.hpp> 
#include <godot_cpp/core/class_db.hpp>

namespace godot {

class FallingObject : public Area2D {
    GDCLASS(FallingObject, Area2D)

private:
    float speed;
    bool is_dragging;
    Vector2 target_position;
    String trash_type;

    // --- EL CANDADO MAESTRO NATIVO ---
    static bool alguien_esta_siendo_arrastrado;

protected:
    static void _bind_methods();

public:
    FallingObject();
    ~FallingObject();

    void _process(double delta) override;
    void _input_event(Viewport *viewport, const Ref<InputEvent> &event, int32_t shape_idx) override;
    void _input(const Ref<InputEvent> &event) override;

    void setup(Vector2 center, float scatter_radius);
    
    // --- FUNCIONES PARA LA VELOCIDAD ---
    void set_speed(const float p_speed) { speed = p_speed; }
    float get_speed() const { return speed; }
    
    // --- FUNCIONES PARA EL TIPO DE BASURA ---
    void set_trash_type(const String p_type) { trash_type = p_type; }
    String get_trash_type() const { return trash_type; }

    bool get_is_dragging() const { return is_dragging; }
};

} // namespace godot

#endif