within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences;
block CapacityRequirement
  "Heating capacity requirement"

  parameter Real avePer(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 300
    "Time period for the rolling average";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,50},{-120,90}}),
      iconTransformation(extent={{-140,50},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    final displayUnit="m3/s")
    "Measured hot water flow rate"
    annotation (Placement(transformation(extent={{-160,-90},{-120,-50}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="Power",
    final unit="W",
    final displayUnit="W")
    "Hot water heating capacity requirement"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  constant Real rhoWat(
    final unit="kg/m3",
    final quantity="Density") = 1000
    "Water density";

  constant Real cpWat(
    final unit="J/(kg.K)",
    final quantity="SpecificHeatCapacity") = 4184
    "Specific heat capacity of water";

  Buildings.Controls.OBC.CDL.Reals.Max max
    "Ensure negative heating requirement calculation is not passed downstream"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=0)
    "Lowest allowed heating requirement"
    annotation (Placement(transformation(extent={{60,24},{80,44}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant density(
    final k=rhoWat)
    "Water density"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant speHeaCap(
    final k=cpWat)
    "Specific heat capacity of water"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Difference between supply temperature setpoint and return temperature"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  Buildings.Controls.OBC.CDL.Reals.MovingAverage movMea(
    final delta=avePer)
    "Moving average"
    annotation (Placement(transformation(extent={{60,-16},{80,4}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro
    "Product"
    annotation (Placement(transformation(extent={{20,-16},{40,4}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro1
    "Product"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro2
    "Product"
    annotation (Placement(transformation(extent={{-20,-22},{0,-2}})));

equation
  connect(TRet,sub2. u2)
    annotation (Line(points={{-140,0},{-110,0},{-110,34},{-102,34}},
      color={0,0,127}));
  connect(sub2.u1, TSupSet)
    annotation (Line(points={{-102,46},{-110,46},{-110,70},{-140,70}},
      color={0,0,127}));
  connect(sub2.y, pro.u1)
    annotation (Line(points={{-78,40},{10,40},{10,0},{18,0}},
      color={0,0,127}));
  connect(pro.y, movMea.u)
    annotation (Line(points={{42,-6},{58,-6}},
      color={0,0,127}));
  connect(speHeaCap.y, pro1.u2)
    annotation (Line(points={{-78,-70},{-70,-70},{-70,-56},{-62,-56}},
      color={0,0,127}));
  connect(pro1.y, pro2.u2)
    annotation (Line(points={{-38,-50},{-30,-50},{-30,-18},{-22,-18}},
      color={0,0,127}));
  connect(pro.u2, pro2.y)
    annotation (Line(points={{18,-12},{2,-12}},
      color={0,0,127}));
  connect(pro1.u1, density.y)
    annotation (Line(points={{-62,-44},{-70,-44},{-70,-30},{-78,-30}},
      color={0,0,127}));
  connect(VHotWat_flow, pro2.u1)
    annotation (Line(points={{-140,-70},{-110,-70},{-110,-6},{-22,-6}},
      color={0,0,127}));
  connect(movMea.y, max.u2)
    annotation (Line(points={{82,-6},{88,-6}},
      color={0,0,127}));
  connect(con.y, max.u1)
    annotation (Line(points={{82,34},{86,34},{86,6},{88,6}},
      color={0,0,127}));
  connect(max.y, y)
    annotation (Line(points={{112,0},{140,0}},
      color={0,0,127}));

  annotation (defaultComponentName = "capReq",
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-62,88},{60,-76}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Load")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-120,-100},{120,100}})),
    Documentation(info="<html>
      <p>
      Calculates heating capacity requirement based on the measured hot water return
      temperature, <code>TRet</code>, calculated hot water supply temperature
      setpoint <code>TSupSet</code>, and the measured hot water flow rate,
      <code>VHotWat_flow</code>.
      <br/> 
      The calculation is according to section 5.3.3.5 and 5.3.3.6. in RP-1711, March
      2020 draft.
      </p>
      </html>",
      revisions="<html>
      <ul>
      <li>
      May 19, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end CapacityRequirement;
