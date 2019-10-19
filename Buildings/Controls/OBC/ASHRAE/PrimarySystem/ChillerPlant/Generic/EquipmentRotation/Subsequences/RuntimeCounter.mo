within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences;
block RuntimeCounter "Equipment rotation signal based on runtime and status"

  parameter Boolean lag = true
    "true = lead/lag, false = lead/standby";

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Initiation"));

  parameter Modelica.SIunits.Time stagingRuntime(
    final displayUnit = "h") = 864000
    "Staging runtime for each device";

  CDL.Continuous.GreaterEqualThreshold                        greEquThr[nDev](final
      threshold=stagingRuntimes)
    "Staging runtime hysteresis"
    annotation (Placement(transformation(extent={{-52,26},{-32,46}})));
  CDL.Logical.Timer                        tim[nDev](final reset={false,false})
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-132,26},{-112,46}})));
  CDL.Logical.And3                        and3[nDev] "Logical and"
    annotation (Placement(transformation(extent={{-12,-14},{8,6}})));
  CDL.Logical.MultiOr                        mulOr(final nu=nDev)
                   "Array input or"
    annotation (Placement(transformation(extent={{28,-14},{48,6}})));
  CDL.Logical.Not                        not0[nDev] "Logical not"
    annotation (Placement(transformation(extent={{28,-44},{48,-24}})));
  CDL.Logical.LogicalSwitch                        logSwi[nDev]
    "Switch"
    annotation (Placement(transformation(extent={{98,-44},{118,-24}})));
  CDL.Routing.BooleanReplicator                        booRep(final nout=nDev)
                     "Signal replicator"
    annotation (Placement(transformation(extent={{58,-14},{78,6}})));
  CDL.Logical.Pre                        pre[nDev](final pre_u_start=initRoles)
                                 "Previous timestep"
    annotation (Placement(transformation(extent={{138,-64},{158,-44}})));
  CDL.Logical.FallingEdge                        falEdg1[nDev]
    "Falling Edge"
    annotation (Placement(transformation(extent={{28,26},{48,46}})));
  CDL.Logical.MultiAnd allOn(nu=2)
    "Outputs true if all devices are commanded enable"
    annotation (Placement(transformation(extent={{-132,-4},{-112,16}})));
  CDL.Logical.MultiOr anyOn(nu=2) "Checks if any device is commanded enable"
    annotation (Placement(transformation(extent={{-172,-44},{-152,-24}})));
  CDL.Logical.Not allOff "Returns true if all devices are commanded disable"
    annotation (Placement(transformation(extent={{-132,-44},{-112,-24}})));
  CDL.Routing.BooleanReplicator booRep1(nout=nDev)
    annotation (Placement(transformation(extent={{-52,-14},{-32,6}})));
  CDL.Logical.Or equSig
    "Outputs true if either all devices are commanded enable or all devices are commanded disable"
    annotation (Placement(transformation(extent={{-92,-14},{-72,6}})));
protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Modelica.SIunits.Time stagingRuntimes[nDev] = fill(stagingRuntime, nDev)
    "Staging runtimes array";

equation
  connect(greEquThr.y,and3. u1) annotation (Line(points={{-30,36},{-22,36},{-22,
          4},{-14,4}},   color={255,0,255}));
  connect(logSwi.u1,not0. y) annotation (Line(points={{96,-26},{68,-26},{68,-34},
          {50,-34}},
                 color={255,0,255}));
  connect(mulOr.u[1:2],and3. y)
    annotation (Line(points={{26,-4},{10,-4}},color={255,0,255}));
  connect(mulOr.y,booRep. u) annotation (Line(points={{50,-4},{56,-4}},
    color={255,0,255}));
  connect(logSwi.u2,booRep. y) annotation (Line(points={{96,-34},{88,-34},{88,
          -4},{80,-4}},
                color={255,0,255}));
  connect(logSwi.y,pre. u) annotation (Line(points={{120,-34},{128,-34},{128,
          -54},{136,-54}},
                 color={255,0,255}));
  connect(pre.y,not0. u) annotation (Line(points={{160,-54},{178,-54},{178,-74},
          {8,-74},{8,-34},{26,-34}},   color={255,0,255}));
  connect(pre.y,logSwi. u3) annotation (Line(points={{160,-54},{168,-54},{168,
          -68},{88,-68},{88,-42},{96,-42}},
                                     color={255,0,255}));
  connect(tim.u0,falEdg1. y) annotation (Line(points={{-134,28},{-142,28},{-142,
          66},{58,66},{58,36},{50,36}}, color={255,0,255}));
  connect(pre.y,and3. u3) annotation (Line(points={{160,-54},{188,-54},{188,-80},
          {-22,-80},{-22,-12},{-14,-12}},
                                        color={255,0,255}));
  connect(tim.y,greEquThr. u)
    annotation (Line(points={{-110,36},{-54,36}},color={0,0,127}));
  connect(pre.y,falEdg1. u)
    annotation (Line(points={{160,-54},{188,-54},{188,16},{8,16},{8,36},{26,36}},
                color={255,0,255}));
  connect(logSwi.y, yDevRolSet) annotation (Line(points={{120,-34},{208,-34},{
          208,-24},{238,-24}}, color={255,0,255}));
  connect(logSwi1.y,tim. u) annotation (Line(points={{-190,-34},{-182,-34},{
          -182,36},{-134,36}},                  color={255,0,255}));
  connect(logSwi1.y, allOn.u[1:2]) annotation (Line(points={{-190,-34},{-182,
          -34},{-182,6},{-134,6},{-134,2.5}}, color={255,0,255}));
  connect(booRep1.y, and3.u2)
    annotation (Line(points={{-30,-4},{-14,-4}}, color={255,0,255}));
  connect(anyOn.y, allOff.u)
    annotation (Line(points={{-150,-34},{-134,-34}}, color={255,0,255}));
  connect(booRep1.u, equSig.y)
    annotation (Line(points={{-54,-4},{-70,-4}}, color={255,0,255}));
  connect(allOff.y, equSig.u2) annotation (Line(points={{-110,-34},{-102,-34},{
          -102,-12},{-94,-12}}, color={255,0,255}));
  connect(allOn.y, equSig.u1) annotation (Line(points={{-110,6},{-102,6},{-102,
          -4},{-94,-4}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-100},{160,100}})),
      defaultComponentName="equRot",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
      Line(points={{-66,-70},{82,-70}},
        color={192,192,192}),
      Line(points={{-58,68},{-58,-80}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-58,90},{-66,68},{-50,68},{-58,90}}),
      Line(points={{-56,-70},{-38,-70},{-38,-26},{40,-26},{40,-70},{68,-70}},
        color={255,0,255}),
      Line(points={{-58,0},{-40,0},{40,90},{40,0},{68,0}},
        color={0,0,127})}),
  Documentation(info="<html>
<p>
This block rotates equipment, such as chillers, pumps or valves, in order 
to ensure equal wear and tear. It can be used for lead/lag and 
lead/standby operation, as specified in &quot;ASHRAE Fundamentals of Chilled Water Plant Design and Control SDL&quot;, 
Chapter 7, App B, 1.01, A.4.  The output vector <code>yDevRol<\code> indicates the lead/lag (or lead/standby) status
of the devices, while the <code>yDevSta<\code> indicates the on/off status of each device. The index of
output vectors and <code>initRoles<\code> parameter represents the physical device.
Default initial lead role is assigned to the device associated
with the first index in the input vector. The block measures the <code>stagingRuntime<\code> 
for each device and switches the lead role to the next higher index
as its <code>stagingRuntime<\code> expires. This block can be used for 2 devices. 
If using more than 2 devices, see 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationMult\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationMult</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 18, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end RuntimeCounter;
