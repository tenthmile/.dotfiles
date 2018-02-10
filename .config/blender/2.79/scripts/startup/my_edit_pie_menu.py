import bpy
from bpy.types import Menu

class VIEW3D_PIE_template(Menu):
    # label is displayed at the center of the pie menu.
    bl_label = "Common Edit Mode Tools"
    bl_idname = "mesh.mypie"

    def draw(self, context):
        layout = self.layout

        pie = layout.menu_pie()
        pie.operator("view3d.edit_mesh_extrude_move_normal", text="Extrude Region")
        pie.operator("mesh.select_mode", text="Vertex", icon='VERTEXSEL').type = 'VERT'
        pie.operator("mesh.subdivide")
        pie.operator("mesh.duplicate_move", text="Duplicate")
        pie.operator("mesh.bevel", text="Bevel (Press 'V' for Vextex-Only, Scroll for Detail)")
        pie.operator("mesh.select_mode", text="Edge", icon='EDGESEL').type = 'EDGE'
        pie.operator("mesh.loopcut_slide")
        pie.operator("mesh.select_mode", text="Face", icon='FACESEL').type = 'FACE'

def register():
    bpy.utils.register_class(VIEW3D_PIE_template)
    wm = bpy.context.window_manager
    km = wm.keyconfigs.addon.keymaps.new(name="Mesh")
    kmi = km.keymap_items.new("wm.call_menu_pie", "BUTTON4MOUSE", "PRESS").properties.name="mesh.mypie"


def unregister():
    bpy.utils.unregister_class(VIEW3D_PIE_template)


if __name__ == "__main__":
    register()
    #bpy.ops.wm.call_menu_pie(name="VIEW3D_PIE_template")
