within Buildings.Fluid.Chillers.Examples;
model ElectricReformulatedEIR
  "Test model for chiller electric reformulated EIR"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric(
      P_nominal=-per.QEva_flow_nominal/per.COP_nominal,
      mEva_flow_nominal=per.mEva_flow_nominal,
      mCon_flow_nominal=per.mCon_flow_nominal,
    sou1(nPorts=1),
    sou2(nPorts=1));

  parameter
    Data.ElectricReformulatedEIR.ReformEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
    per "Chiller performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  Buildings.Fluid.Chillers.ElectricReformulatedEIR chi(
       redeclare package Medium1 = Medium1,
       redeclare package Medium2 = Medium2,
       per=per,
       energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
       dp1_nominal=6000,
       dp2_nominal=6000) "Chiller model"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

equation
  connect(sou1.ports[1], chi.port_a1) annotation (Line(
      points={{-40,16},{0,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b1, res1.port_a) annotation (Line(
      points={{20,16},{26,16},{26,40},{32,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], chi.port_a2) annotation (Line(
      points={{40,4},{20,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b2, res2.port_a) annotation (Line(
      points={{0,4},{-10,4},{-10,-20},{-20,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.on, greaterThreshold.y) annotation (Line(
      points={{-2,13},{-8,13},{-8,90},{-19,90}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TSet.y, chi.TSet) annotation (Line(
      points={{-59,60},{-20,60},{-20,8},{-2,8},{-2,7}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(Tolerance=1e-6, StopTime=14400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/ElectricReformulatedEIR.mos"
        "Simulate and plot"),    Documentation(info="<html>
<p>
Example that simulates a chiller whose efficiency is computed based on the
condenser leaving and evaporator leaving fluid temperature.
A bicubic polynomial is used to compute the chiller part load performance.
</p>
</html>", revisions="<html>
<ul>
<li>
August 14, 2014, by Michael Wetter:<br/>
Added missing <code>redeclare</code> keyword in
performance data redeclaration.
This avoids an error in OpenModelica.
</li>
<li>
September 17, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ElectricReformulatedEIR;
