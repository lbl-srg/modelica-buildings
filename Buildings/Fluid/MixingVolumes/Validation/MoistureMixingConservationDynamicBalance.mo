within Buildings.Fluid.MixingVolumes.Validation;
model MoistureMixingConservationDynamicBalance
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

    parameter Real[3] m_start(each fixed=false)
    "Initial mass of the mixing volumes";
    parameter Real[3] U_start(each fixed=false)
    "Initial energy of the mixing volumes";
  Modelica.Blocks.Continuous.Integrator intMasFloVapIn(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of added vapour"
    annotation (Placement(transformation(extent={{4,-30},{16,-18}})));
  Modelica.Blocks.Math.Add3 add "Adder for injected water"
    annotation (Placement(transformation(extent={{-14,-18},{-2,-30}})));
  Modelica.Blocks.Sources.RealExpression masVapVol(y=vol.mXi[1] + vol1.mXi[1] +
        vol2.mXi[1]) "Vapour mass stored in mixing volumes"
                                             annotation (Placement(
        transformation(
        extent={{-10,-9},{10,9}},
        rotation=0,
        origin={30,-19})));
  Modelica.Blocks.Math.Add3 add3Vap(k3=-1)
    "Sum of vapour mass should be conserved"
    annotation (Placement(transformation(extent={{60,-24},{70,-14}})));
  Modelica.Blocks.Sources.RealExpression masVol(y=vol1.m + vol.m + vol2.m)
    "Mass stored in mixing volumes"                    annotation (Placement(
        transformation(
        extent={{-10,-9},{10,9}},
        rotation=0,
        origin={30,-49})));
  Modelica.Blocks.Continuous.Integrator intMasFloOut(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of leaving mass" annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=270,
        origin={44,6})));
  Modelica.Blocks.Math.Add3 add3Mass(k3=-1) "Adding 3 mass streams"
    annotation (Placement(transformation(extent={{60,-54},{70,-44}})));
  Modelica.Blocks.Continuous.Integrator intMasFloIn(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of added mass"
    annotation (Placement(transformation(extent={{4,-60},{16,-48}})));
  Modelica.Blocks.Sources.Constant masFloIn(k=sou1.m_flow + sou2.m_flow)
    "Added air mass flow rate"
    annotation (Placement(transformation(extent={{-14,-60},{-2,-48}})));
  Modelica.Blocks.Continuous.Integrator intEntOut(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of leaving enthalpy"
                                          annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=270,
        origin={20,6})));
  Modelica.Blocks.Continuous.Integrator intEntIn(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of added enthalpy"
    annotation (Placement(transformation(extent={{4,-92},{16,-80}})));
  Modelica.Blocks.Sources.RealExpression entVol(y=vol1.U + vol.U + vol2.U)
    "Energy stored in mixing volumes"                    annotation (Placement(
        transformation(
        extent={{-10,-9},{10,9}},
        rotation=0,
        origin={30,-81})));
  Modelica.Blocks.Math.Add3 add3Ent(k3=-1) "Adding 3 enthalpy streams"
    annotation (Placement(transformation(extent={{60,-86},{70,-76}})));
  Modelica.Blocks.Sources.Constant entIn(k=sou1.m_flow*sou1.h + sou2.m_flow*
        sou2.h + Medium.enthalpyOfLiquid(TWat.k)*(mWatFlo1.k + mWatFlo2.k))
    "Added enthalpy"
    annotation (Placement(transformation(extent={{-14,-92},{-2,-80}})));
  Modelica.Blocks.Math.Product pro "Water vapor flow rate" annotation (
      Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={65,11})));
  Modelica.Blocks.Continuous.Integrator intMasVapOut(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integral of leaving vapor mass" annotation (Placement(
        transformation(
        extent={{-5,5},{5,-5}},
        rotation=270,
        origin={65,-1})));
initial equation
  m_start = {vol.m, vol1.m,vol2.m};
  U_start = {vol.U, vol1.U,vol2.U};

equation
  connect(add.u1, mWatFlo2.y) annotation (Line(
      points={{-15.2,-28.8},{-16,-28.8},{-16,-32},{-62,-32},{-62,-10},{-83.2,
          -10}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(add.u2, mWatFlo1.y) annotation (Line(
      points={{-15.2,-24},{-62,-24},{-62,60},{-83.2,60}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(add3Vap.y, assMasFra.u2) annotation (Line(
      points={{70.5,-19},{76.25,-19},{76.25,-24.8},{82.6,-24.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masVapVol.y,add3Vap. u2) annotation (Line(
      points={{41,-19},{59,-19}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasFloVapIn.u, add.y) annotation (Line(
      points={{2.8,-24},{-1.4,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasFloVapIn.y,add3Vap. u3) annotation (Line(
      points={{16.6,-24},{38,-24},{38,-23},{59,-23}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMasFlo.m_flow, intMasFloOut.u) annotation (Line(
      points={{44,19},{44,13.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add3Mass.y, assMasFlo.u2) annotation (Line(
      points={{70.5,-49},{76,-49},{76,-54.8},{82.6,-54.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasFloOut.y, add3Mass.u1) annotation (Line(
      points={{44,-0.6},{44,-45},{59,-45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masVol.y, add3Mass.u2) annotation (Line(
      points={{41,-49},{59,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasFloIn.y, add3Mass.u3) annotation (Line(
      points={{16.6,-54},{38,-54},{38,-53},{59,-53}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasFloIn.u, masFloIn.y) annotation (Line(
      points={{2.8,-54},{-1.4,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add3Ent.y, assSpeEnt.u2) annotation (Line(
      points={{70.5,-81},{76.25,-81},{76.25,-86.8},{82.6,-86.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(entVol.y, add3Ent.u2) annotation (Line(
      points={{41,-81},{59,-81}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intEntIn.y, add3Ent.u3) annotation (Line(
      points={{16.6,-86},{38,-86},{38,-85},{59,-85}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(entIn.y, intEntIn.u) annotation (Line(
      points={{-1.4,-86},{2.8,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add3Ent.u1, intEntOut.y) annotation (Line(
      points={{59,-77},{20,-77},{20,-0.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intEntOut.u, senSpeEnt.H_flow) annotation (Line(
      points={{20,13.2},{20,19}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.u3, mWatFlo3.y) annotation (Line(
      points={{-15.2,-19.2},{-23.2,-19.2},{-23.2,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pro.u1, senMasFra.X) annotation (Line(
      points={{68,17},{68,19}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pro.u2, senMasFlo.m_flow) annotation (Line(
      points={{62,17},{62,19},{44,19}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pro.y, intMasVapOut.u) annotation (Line(
      points={{65,5.5},{65,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intMasVapOut.y, add3Vap.u1) annotation (Line(
      points={{65,-6.5},{65,-10},{54,-10},{54,-15},{59,-15}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Documentation(info="<html>
<p>
This model verifies if mass and energy are conserved, 
using a dynamic balance. 
Two air streams with different mass flow rate are humidified 
by a mixing volume with two different vapor mass flow rates. 
These flows are then mixed. 
Boundary integrals are used to verify if air mass,
vapour mass and internal energy are conserved.
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
        "Simulate and plot"));
end MoistureMixingConservationDynamicBalance;
