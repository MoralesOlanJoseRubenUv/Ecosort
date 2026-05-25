#include "falling_object.hpp"
#include <godot_cpp/classes/random_number_generator.hpp>
#include <godot_cpp/classes/input_event_mouse_button.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void FallingObject::_bind_methods() {
    ClassDB::bind_method(D_METHOD("setup", "center", "scatter_radius"), &FallingObject::setup);
    ClassDB::bind_method(D_METHOD("get_trash_type"), &FallingObject::get_trash_type);
    ClassDB::bind_method(D_METHOD("set_trash_type", "p_type"), &FallingObject::set_trash_type);
    ClassDB::bind_method(D_METHOD("get_is_dragging"), &FallingObject::get_is_dragging);
    
    // NUEVO: Métodos para la velocidad
    ClassDB::bind_method(D_METHOD("set_speed", "p_speed"), &FallingObject::set_speed);
    ClassDB::bind_method(D_METHOD("get_speed"), &FallingObject::get_speed);

    ADD_PROPERTY(PropertyInfo(Variant::STRING, "trash_type"), "set_trash_type", "get_trash_type");
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "is_dragging"), "", "get_is_dragging");
    
    // NUEVO: Propiedad para que el spawner la vea
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "speed"), "set_speed", "get_speed");
}

FallingObject::FallingObject() {
    speed = 150.0f;
    is_dragging = false;
    trash_type = "indefinido";
    target_position = get_global_position(); 
}

FallingObject::~FallingObject() {}

void FallingObject::setup(Vector2 center, float scatter_radius) {
    Ref<RandomNumberGenerator> rng;
    rng.instantiate();
    rng->randomize();

    float angle = rng->randf_range(0, Math_PI * 2.0);
    float distance = rng->randf_range(0, scatter_radius);
    target_position = center + Vector2(Math::cos(angle), Math::sin(angle)) * distance;
}

void FallingObject::_process(double delta) {
    if (is_dragging) {
        set_global_position(get_global_mouse_position());
    } else {
        Vector2 current_pos = get_global_position();
        if (current_pos.distance_to(target_position) > 5.0f) {
            Vector2 direction = (target_position - current_pos).normalized();
            set_global_position(current_pos + direction * speed * (float)delta);
        }
    }
}

void FallingObject::_input_event(Viewport *viewport, const Ref<InputEvent> &event, int32_t shape_idx) {
    Ref<InputEventMouseButton> mb = event;
    if (mb.is_valid() && mb->get_button_index() == MOUSE_BUTTON_LEFT) {
        if (mb->is_pressed()) {
            is_dragging = true;
            set_z_index(10);
        }
    }
}

void FallingObject::_input(const Ref<InputEvent> &event) {
    Ref<InputEventMouseButton> mb = event;
    if (mb.is_valid() && mb->get_button_index() == MOUSE_BUTTON_LEFT && !mb->is_pressed()) {
        if (is_dragging) {
            is_dragging = false;
            set_z_index(0);
        }
    }
}