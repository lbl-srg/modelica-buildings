within Buildings.Applications.DHC.EnergyTransferStations.Control;
model PrimaryPumpsConstantSpeed
  "The control block of the constant speed condenser and the evaporator water pumps."
     extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal( final displayUnit="kg/s")
     "Condenser nominal water flow rate";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal(final displayUnit="kg/s")
     "Evaporator nominal water flow rate";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqCoo
    "Cooling is required Boolean signal"
    annotation (Placement(transformation(extent={{-128,4},{-100,32}}),
        iconTransformation(extent={{-128,-112},{-100,-84}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqHea
    "Heating is required Boolean signal"
    annotation (Placement(transformation(extent={{-128,26},{-100,54}}),
        iconTransformation(extent={{-128,86},{-100,114}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumCon
    "Condenser pump speed outlet signal"  annotation (Placement(transformation(
          extent={{200,144},{232,176}}), iconTransformation(extent={{100,70},{120,
            90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumEva
    "Evaporator pump speed outlet signal" annotation (Placement(transformation(
          extent={{200,-96},{232,-64}}), iconTransformation(extent={{100,-90},{120,
            -70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant shuOffSig(k=0)
    "HeatPump, condenser pump  and evaporator pump shut off signal =0"
   annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{120,22},{140,42}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-40,22},{-20,42}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant pumOnSig(k=1)
    "Pump turn on signal "
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
equation
  connect(yPumEva,yPumEva) annotation (Line(points={{216,-80},{216,-80}}, color={0,0,127}));
  connect(reqHea, or2.u1) annotation (Line(
      points={{-114,40},{-78,40},{-78,32},{-42,32}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(reqCoo, or2.u2) annotation (Line(points={{-114,18},{-78,18},{-78,24},{
          -42,24}},   color={255,0,255},
      pattern=LinePattern.Dot));
  connect(shuOffSig.y, swi1.u3) annotation (Line(
      points={{102,10},{106,10},{106,24},{118,24}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(or2.y, swi1.u2) annotation (Line(points={{-18,32},{118,32}},
                color={255,0,255}));
  connect(yPumCon,yPumCon) annotation (Line(points={{216,160},{216,160}},
                                                 color={0,0,127}));
  connect(swi1.y,yPumCon)  annotation (Line(points={{142,32},{158,32},{158,160},
          {216,160}},
        color={0,0,127}));
  connect(swi1.y,yPumEva)  annotation (Line(points={{142,32},{158,32},{158,-80},
          {216,-80}},
        color={0,0,127}));
  connect(swi1.u1, pumOnSig.y) annotation (Line(points={{118,40},{110,40},{110,
          50},{102,50}}, color={0,0,127}));
  annotation (defaultComponentName="pumCon",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,180}})),
        Documentation(info="<html>
<p>
The block computes the control signals for
</p>
<h4>Chiller condenser pump</h4>
<p>
The heat pump condenser pump is constant speed and switched on and off based on a supervisory control signal
generated from the <a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController</a>
</p>
<h4>Chiller evaporator pump</h4>
<p>
The chiller evaporator pump is constant speed and switched on and off based on a supervisory control signal.
generated from the <a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController</a>
</p>

</html>", revisions="<html>
<ul>
<li>
November 25, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrimaryPumpsConstantSpeed;
