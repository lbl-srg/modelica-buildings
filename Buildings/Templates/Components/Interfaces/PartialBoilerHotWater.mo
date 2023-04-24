within Buildings.Templates.Components.Interfaces;
partial model PartialBoilerHotWater "Interface class for chiller models"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=mHeaWat_flow_nominal);

  parameter Buildings.Templates.Components.Types.BoilerHotWaterModel typMod
    "Type of boiler model"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Components.Data.BoilerHotWater dat(
    final typMod=typMod)
    "Design and operating parameters";

  parameter Boolean is_con
    "Set to true for condensing boiler, false for non-condensing boiler"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
    dat.mHeaWat_flow_nominal
    "HW mass flow rate";
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal=
    dat.cap_nominal
    "Heating capacity";
  final parameter Modelica.Units.SI.PressureDifference dpHeaWat_nominal=
    dat.dpHeaWat_nominal
    "HW pressure drop";
  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=
    dat.THeaWatSup_nominal
    "HW supply temperature";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  Buildings.Templates.Components.Interfaces.Bus bus
    "Control bus"
    annotation (Placement(transformation(extent={{-20,80},{20,120}}),
     iconTransformation(extent={{-20,80},{20, 120}})));

  annotation (Documentation(info="<html>
<p>
This partial class provides a standard interface for hot water boiler models.
</p>
</html>", revisions="<html>
<ul>
<li>
March 31, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
    Rectangle(
          extent={{100,60},{-100,-60}},
          lineColor={0,0,0},
          lineThickness=1),
    Text(
          extent={{-60,20},{60,-20}},
          textColor={0,0,0},
          textString="BOI"),
    Bitmap(extent={{-20,60},{20,100}}, fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg")}));
end PartialBoilerHotWater;
