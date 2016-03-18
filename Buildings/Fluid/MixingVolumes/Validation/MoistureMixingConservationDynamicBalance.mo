within Buildings.Fluid.MixingVolumes.Validation;
model MoistureMixingConservationDynamicBalance
  "This test checks if mass and energy is conserved when mixing fluid streams using dynamic balances"
  extends
    Buildings.Fluid.MixingVolumes.Validation.BaseClasses.MoistureMixingConservation(
    mWatFloSol(k={vol.X_start[1],vol1.X_start[1],vol2.X_start[1]}*m_start),
    vol(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics=
         Modelica.Fluid.Types.Dynamics.FixedInitial),
    vol1(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    vol2(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    mFloSol(k=sum(m_start)),
    hSol(k=sum(U_start)),
    mWatFlo3(k=0));

    parameter Modelica.SIunits.Mass[3] m_start(each fixed=false)
    "Initial mass of the mixing volumes";
    parameter Modelica.SIunits.InternalEnergy[3] U_start(each fixed=false)
    "Initial energy of the mixing volumes";
  Modelica.Blocks.Continuous.Integrator intMasFloVapIn(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of added vapour"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Modelica.Blocks.Math.Add3 add "Adder for injected water"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-80}})));
  Modelica.Blocks.Sources.RealExpression masVapVol(y=vol.mXi[1] + vol1.mXi[1] +
        vol2.mXi[1]) "Vapour mass stored in mixing volumes"
                                             annotation (Placement(
        transformation(
        extent={{-32,-10},{32,10}},
        rotation=0,
        origin={-32,-50})));
  Modelica.Blocks.Math.Add3 add3Vap(k3=-1)
    "Sum of vapour mass should be conserved"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Modelica.Blocks.Sources.RealExpression masVol(y=vol1.m + vol.m + vol2.m)
    "Mass stored in mixing volumes"                    annotation (Placement(
        transformation(
        extent={{-40,-10},{40,10}},
        rotation=0,
        origin={-40,-130})));
  Modelica.Blocks.Continuous.Integrator intMasFloOut(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of leaving mass" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={50,-10})));
  Modelica.Blocks.Math.Add3 add3Mass(k3=-1) "Adding 3 mass streams"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
  Modelica.Blocks.Continuous.Integrator intMasFloIn(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of added mass"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Modelica.Blocks.Sources.Constant masFloIn(k=sou1.m_flow + sou2.m_flow)
    "Added air mass flow rate"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  Modelica.Blocks.Continuous.Integrator intEntOut(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of leaving enthalpy"
                                          annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={30,-30})));
  Modelica.Blocks.Continuous.Integrator intEntIn(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of added enthalpy"
    annotation (Placement(transformation(extent={{0,-242},{20,-222}})));
  Modelica.Blocks.Sources.RealExpression entVol(y=vol1.U + vol.U + vol2.U)
    "Energy stored in mixing volumes"                    annotation (Placement(
        transformation(
        extent={{-40,-10},{40,10}},
        rotation=0,
        origin={-40,-212})));
  Modelica.Blocks.Math.Add3 add3Ent(k3=-1) "Adding 3 enthalpy streams"
    annotation (Placement(transformation(extent={{60,-222},{80,-202}})));
  Modelica.Blocks.Sources.Constant entIn(k=sou1.m_flow*sou1.h + sou2.m_flow*
        sou2.h + Medium.enthalpyOfLiquid(TWat.k)*(mWatFlo1.k + mWatFlo2.k))
    "Added enthalpy"
    annotation (Placement(transformation(extent={{-40,-242},{-20,-222}})));
  Modelica.Blocks.Math.Product pro "Water vapor flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={110,-10})));
  Modelica.Blocks.Continuous.Integrator intMasVapOut(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of leaving vapor mass" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={90,-30})));
initial equation
  m_start = {vol.m, vol1.m,vol2.m};
  U_start = {vol.U, vol1.U,vol2.U};

equation
  connect(add.u1, mWatFlo2.y) annotation (Line(
      points={{-42,-78},{-70,-78},{-70,-50},{-79,-50}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(add.u2, mWatFlo1.y) annotation (Line(
      points={{-42,-70},{-70,-70},{-70,60},{-79,60}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(add3Vap.y, assMasFra.u2) annotation (Line(
      points={{81,-50},{100.25,-50},{100.25,-44},{138,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masVapVol.y,add3Vap. u2) annotation (Line(
      points={{3.2,-50},{58,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasFloVapIn.u, add.y) annotation (Line(
      points={{-2,-70},{-19,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasFloVapIn.y,add3Vap. u3) annotation (Line(
      points={{21,-70},{40,-70},{40,-58},{58,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMasFlo.m_flow, intMasFloOut.u) annotation (Line(
      points={{70,9},{70,10},{50,10},{50,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add3Mass.y, assMasFlo.u2) annotation (Line(
      points={{81,-130},{100,-130},{100,-124},{138,-124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masVol.y, add3Mass.u2) annotation (Line(
      points={{4,-130},{58,-130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasFloIn.y, add3Mass.u3) annotation (Line(
      points={{21,-150},{40,-150},{40,-138},{58,-138}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasFloIn.u, masFloIn.y) annotation (Line(
      points={{-2,-150},{-19,-150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add3Ent.y, assSpeEnt.u2) annotation (Line(
      points={{81,-212},{100.25,-212},{100.25,-204},{138,-204}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(entVol.y, add3Ent.u2) annotation (Line(
      points={{4,-212},{58,-212}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intEntIn.y, add3Ent.u3) annotation (Line(
      points={{21,-232},{40,-232},{40,-220},{58,-220}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(entIn.y, intEntIn.u) annotation (Line(
      points={{-19,-232},{-2,-232}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add3Ent.u1, intEntOut.y) annotation (Line(
      points={{58,-204},{30,-204},{30,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intEntOut.u, senSpeEnt.H_flow) annotation (Line(
      points={{30,-18},{30,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.u3, mWatFlo3.y) annotation (Line(
      points={{-42,-62},{-70,-62},{-70,60},{-12,60},{-12,70},{-19,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pro.u1, senMasFra.X) annotation (Line(
      points={{116,2},{116,9},{110,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pro.u2, senMasFlo.m_flow) annotation (Line(
      points={{104,2},{104,9},{70,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasVapOut.y, add3Vap.u1) annotation (Line(
      points={{79,-30},{54,-30},{54,-42},{58,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasVapOut.u, pro.y)
    annotation (Line(points={{102,-30},{110,-30},{110,-21}}, color={0,0,127}));
  connect(add3Mass.u1, intMasFloOut.y)
    annotation (Line(points={{58,-122},{50,-122},{50,-21}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -280},{180,120}})),           Documentation(info="<html>
<p>
This model verifies if mass and energy are conserved, 
using a dynamic balance. 
Two air streams with different mass flow rate are humidified 
by a mixing volume with two different vapor mass flow rates. 
These flows are then mixed. 
Boundary integrals are used to verify if air mass,
vapour mass and internal energy are conserved.
</p>
<p>
Note, however, that there is some approximation error because
in its default configuration, the conservation balance
models simplify the treatment of the water that is added
to the fluid.
See <a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</a>
and
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</a>
for a discussion.
</p>
</html>", revisions="<html>
<ul>
<li>
May 22 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MoistureMixingConservationDynamicBalance.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end MoistureMixingConservationDynamicBalance;
