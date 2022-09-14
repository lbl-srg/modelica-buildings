within Buildings.Templates.Components.Pumps.Interfaces;
model PartialPump "Base class for all pump models"
  parameter Buildings.Templates.Components.Types.Pump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Boolean have_valChe=true
    "Set to true to include a check valve in pump line"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  Buildings.Templates.Components.Interfaces.Bus bus
    "Control bus"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (Icon(graphics={
        Text(
          extent={{-149,-112},{151,-152}},
          textColor={0,0,255},
          textString="%name")}));
end PartialPump;
