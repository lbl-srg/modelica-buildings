within Buildings.Templates.Components.Interfaces;
model PartialPump "Base class for all pump models"
  parameter Buildings.Templates.Components.Types.Pump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Boolean have_var=true
    "Set to true for variable speed pump, false for constant speed pump"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));
  parameter Boolean have_varCom=true
    "Set to true for single common speed signal, false for dedicated signals"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typ==Buildings.Templates.Components.Types.Pump.Multiple and have_var));

  parameter Boolean have_valChe=true
    "Set to true to include a check valve in pump line"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None),
    __Linkage(enable=false));

  parameter Boolean addPowerToMedium=false
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)"
    annotation(__Linkage(enable=false));

  parameter Modelica.Units.SI.Time tau=1
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic"
    annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState),
      __Linkage(enable=false));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"),
      __Linkage(enable=false));
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true, __Linkage(enable=false));

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

  annotation (                   Documentation(info="<html>
<p>
This partial class provides a standard interface for pump models.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
    Line(
      points={{-100,0},{100,0}},
      color={0,0,0},
      thickness=1),
    Bitmap(
      visible=typ <> Buildings.Templates.Components.Types.Pump.None and
          have_valChe,
      extent={{20,-40},{100,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg"),
    Bitmap(
          visible=typ <> Buildings.Templates.Components.Types.Pump.None,
          extent={{-100,-70},{0,30}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and have_var,
        extent={{-100,60},{0,160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Pump.None and not have_var,
        extent={{-100,60},{0,160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line( visible=typ <> Buildings.Templates.Components.Types.Pump.None,
          points={{-50,60},{-50,22}},
          color={0,0,0})}));
end PartialPump;
