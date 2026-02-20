within Buildings.DHC.ETS.Combined.Controls;
block TwoTankCoordination
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean have_hotWat=true "True if there is integrated DHW";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDhw if have_hotWat
    "Charge request from the domestic hot water tank" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}),  iconTransformation(
          extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Charge request from the heating hot water tank" annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}),iconTransformation(
          extent={{-140,-62},{-100,-22}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Enable command"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMix(final unit="1")
    if have_hotWat "Mixing valve control signal" annotation (Placement(
        transformation(extent={{100,20},{140,60}}),  iconTransformation(extent={{100,30},
            {140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDhw
    "Charge command from DHW tank, or false if no tank present" annotation (
      Placement(transformation(extent={{100,-60},{140,-20}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=false) if not have_hotWat
    "Output true as dummy signal if no DHW is present"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

block WithDHW
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDhw
    "Charge request from the domestic hot water tank" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}),  iconTransformation(
          extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Charge request from the heating hot water tank" annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}),iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMix(final unit="1")
    "Mixing valve control signal" annotation (Placement(
        transformation(extent={{100,40},{140,80}}),  iconTransformation(extent={{100,40},
              {140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Enable command"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
equation
  y =uDhw  or uHea;
  if uDhw and uHea then
   yMix = 0.5;
  elseif uDhw and not uHea then
   yMix = 0;
  elseif uHea and not uDhw then
   yMix = 1;
  else
   yMix = 1;
  end if;

end WithDHW;

block WithoutDHW
  extends Modelica.Blocks.Icons.Block;
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Charge request from the heating hot water tank" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Enable command"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
equation
  connect(uHea, y) annotation (Line(points={{-120,0},{120,0}},
        color={255,0,255}));
end WithoutDHW;

  WithDHW withDHW if have_hotWat
    annotation (Placement(transformation(extent={{-10,24},{10,44}})));
  WithoutDHW withoutDHW if not have_hotWat
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

equation
  connect(withoutDHW.uHea, uHea) annotation (Line(points={{-10,0},{-40,0},{-40,
          -40},{-120,-40}}, color={255,0,255}));
  connect(withDHW.uDhw,uDhw)  annotation (Line(points={{-12,38},{-66,38},{-66,
          60},{-120,60}},
                       color={255,0,255}));
  connect(uHea, withDHW.uHea) annotation (Line(points={{-120,-40},{-40,-40},{
          -40,30},{-12,30}},
                         color={255,0,255}));
  connect(withDHW.yMix, yMix) annotation (Line(points={{12,40},{120,40}},
                    color={0,0,127}));
  connect(withDHW.y, y) annotation (Line(points={{12,34},{70,34},{70,0},{120,0}},
        color={255,0,255}));
  connect(withoutDHW.y, y) annotation (Line(points={{14,0},{120,0}},
               color={255,0,255}));
  connect(uDhw, yDhw) annotation (Line(points={{-120,60},{80,60},{80,-40},{120,-40}},
        color={255,0,255}));
  connect(con.y, yDhw)
    annotation (Line(points={{62,-40},{120,-40}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="
<html>
<p>
This block routes the connectors on the evaporator side of the ETS
depending on whether DHW integration is present.
It also sends a signal to open the diversion valve when there is HHW or DHW
load present. If the DHW integration is present, this block also controls
the mixing valve which directs the condenser water to the HHW or DHW tanks,
sometimes both.
</p>
<p>
When DHW integration is present:
</p>
<table summary=\"summary\"><thead>
  <tr>
    <th colspan=\"2\">Input: load present</th>
    <th colspan=\"4\">Output</th>
  </tr></thead>
<tbody>
  <tr>
    <td>DHW</td>
    <td>HHW</td>
    <td>yMix</td>
    <td>yDiv</td>
    <td>TTop</td>
    <td>TSet</td>
  </tr>
  <tr>
    <td>T</td>
    <td>T</td>
    <td>0.5</td>
    <td>1</td>
    <td>The one with higher TSet</td>
    <td>Max of two</td>
  </tr>
  <tr>
    <td>T</td>
    <td>F</td>
    <td>0</td>
    <td>1</td>
    <td>DHW</td>
    <td>DHW</td>
  </tr>
  <tr>
    <td>F</td>
    <td>T</td>
    <td>1</td>
    <td>1</td>
    <td>HHW</td>
    <td>HHW</td>
  </tr>
  <tr>
    <td>F</td>
    <td>F</td>
    <td>1</td>
    <td>0</td>
    <td>HHW</td>
    <td>HHW</td>
  </tr>
</tbody>
</table>
</html>"));
end TwoTankCoordination;
