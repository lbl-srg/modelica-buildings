within Buildings.Experimental.DHC.Loads.Heating.DHW.BaseClasses;
partial model PartialFourPortDHW
  "A partial model for domestic water heating"
  extends Buildings.Fluid.Interfaces.PartialFourPort(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium);
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal "Nominal mass flow rate of hot water supply";
  parameter Modelica.Units.SI.MassFlowRate mDH_flow_nominal "Nominal mass flow rate of district heating water";
  Modelica.Blocks.Interfaces.RealOutput PHea(unit="W")
    "Electric power required for heating equipment"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TSetHw
    "Temperature setpoint for domestic hot water supply from heater"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Sources.Constant zero(k=0) if have_PEle == false "Zero output"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
protected
  parameter Boolean have_PEle "Flag that specifies whether electric power is required for water heating";
equation
  connect(zero.y,PHea)
    annotation (Line(points={{81,90},{82,90},{82,0},{110,0}},
                                              color={0,0,127}));
  annotation (preferredView="info",Documentation(info="<html>
<p>
This partial model can be used for different domestic hot water generation methods.
</p>
</html>", revisions="<html>
<ul>
<li>
September 29, 2022 by Dre Helmns:<br/>
Created partial model.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFourPortDHW;
