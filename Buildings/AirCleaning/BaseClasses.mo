within Buildings.AirCleaning;
package BaseClasses "Base classes for air cleaning models"

  partial model PartialDuctGUV "Partial model for an in duct GUV"
      extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
       show_T=false,
       dp(nominal=if dp_nominal_pos > Modelica.Constants.eps
            then dp_nominal_pos else 1),
       m_flow(
          nominal=if m_flow_nominal_pos > Modelica.Constants.eps
            then m_flow_nominal_pos else 1),
       final m_flow_small = 1E-4*abs(m_flow_nominal));

    constant Boolean homotopyInitialization = true "= true, use homotopy method"
      annotation(HideResult=true);

    parameter Boolean from_dp = false
      "= true, use m_flow = f(dp) else dp = f(m_flow)"
      annotation (Evaluate=true, Dialog(tab="Advanced"));

    parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
      "Pressure drop at nominal mass flow rate"
      annotation (Dialog(group="Nominal condition"));

    parameter Boolean linearized = false
      "= true, use linear relation between m_flow and dp for any flow rate"
      annotation(Evaluate=true, Dialog(tab="Advanced"));

    parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
      "Turbulent flow if |m_flow| >= m_flow_turbulent";

    parameter Real kGUV[Medium.nC](min=0) = 1
      "Inactivation constant";

    Modelica.Blocks.Math.BooleanToReal booleanToReal
      annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
    Modelica.Blocks.Interfaces.BooleanInput u "on/off"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  protected
    parameter Medium.ThermodynamicState sta_default=
       Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
    parameter Modelica.Units.SI.DynamicViscosity eta_default=
        Medium.dynamicViscosity(sta_default)
      "Dynamic viscosity, used to compute transition to turbulent flow regime";

    final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_pos=abs(
        m_flow_nominal) "Absolute value of nominal flow rate";
    final parameter Modelica.Units.SI.PressureDifference dp_nominal_pos(
        displayUnit="Pa") = abs(dp_nominal)
      "Absolute value of nominal pressure difference";
    Buildings.Fluid.Delays.DelayFirstOrder                 vol(
      redeclare final package Medium = Medium,
      use_C_flow=false,
      final tau=1,
      final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      final m_flow_nominal=m_flow_nominal,
      final m_flow_small=m_flow_small,
      final prescribedHeatFlowRate=true,
      final allowFlowReversal=allowFlowReversal,
      nPorts=2) "Fluid volume for dynamic model"
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  initial equation
    assert(homotopyInitialization, "In " + getInstanceName() +
      ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
      level = AssertionLevel.warning);

  equation

    connect(u,booleanToReal. u)
      annotation (Line(points={{-120,-80},{-82,-80}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={
          Rectangle(
            extent=DynamicSelect({{-100,10},{-100,10}}, {{100,10},{100+200*max(-1, min(0, m_flow/(abs(m_flow_nominal)))),-10}}),
            lineColor={28,108,200},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Rectangle(
            extent=DynamicSelect({{-100,10},{-100,10}}, {{-100,10},{-100+200*min(1, max(0, m_flow/abs(m_flow_nominal))),-10}}),
            lineColor={28,108,200},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None)}),
            defaultComponentName="res",
  Documentation(info="<html>
<p>Partial model for duct GUV.</p>
</html>",   revisions="<html>
<ul>
<li>
March 29, 2024 by Cary Faulkner:<br/>
First implementation.
</li>
</ul>
</html>"));
  end PartialDuctGUV;

  partial model PartialInDuctGUVCalc "Partial model duct GUV calculation"
      extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
       show_T=false,
       dp(nominal=if dp_nominal_pos > Modelica.Constants.eps
            then dp_nominal_pos else 1),
       m_flow(
          nominal=if m_flow_nominal_pos > Modelica.Constants.eps
            then m_flow_nominal_pos else 1),
       final m_flow_small = 1E-4*abs(m_flow_nominal));

    constant Boolean homotopyInitialization = true "= true, use homotopy method"
      annotation(HideResult=true);

    parameter Boolean from_dp = false
      "= true, use m_flow = f(dp) else dp = f(m_flow)"
      annotation (Evaluate=true, Dialog(tab="Advanced"));

    parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
      "Pressure drop at nominal mass flow rate"
      annotation (Dialog(group="Nominal condition"));

    parameter Boolean linearized = false
      "= true, use linear relation between m_flow and dp for any flow rate"
      annotation(Evaluate=true, Dialog(tab="Advanced"));

    parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent
      "Turbulent flow if |m_flow| >= m_flow_turbulent";

    parameter Real kGUV[Medium.nC](min=0)
      "Inactivation constant";

    Modelica.Units.SI.MassFlowRate m_flow_GUV(min = 0)
      "comment";

    Modelica.Blocks.Math.BooleanToReal booleanToReal
      annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
    Modelica.Blocks.Interfaces.BooleanInput u "on/off"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  protected
    parameter Medium.ThermodynamicState sta_default=
       Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
    parameter Modelica.Units.SI.DynamicViscosity eta_default=
        Medium.dynamicViscosity(sta_default)
      "Dynamic viscosity, used to compute transition to turbulent flow regime";

    final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_pos=abs(
        m_flow_nominal) "Absolute value of nominal flow rate";
    final parameter Modelica.Units.SI.PressureDifference dp_nominal_pos(
        displayUnit="Pa") = abs(dp_nominal)
      "Absolute value of nominal pressure difference";
  initial equation
    assert(homotopyInitialization, "In " + getInstanceName() +
      ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
      level = AssertionLevel.warning);

  equation
    // Isenthalpic state transformation (no storage and no loss of energy)
    port_a.h_outflow = if allowFlowReversal then inStream(port_b.h_outflow) else Medium.h_default;
    port_b.h_outflow = inStream(port_a.h_outflow);

    // Mass balance (no storage)
    port_a.m_flow + port_b.m_flow = 0;

    // Transport of substances
    port_a.Xi_outflow = if allowFlowReversal then inStream(port_b.Xi_outflow) else Medium.X_default[1:Medium.nXi];
    port_b.Xi_outflow = inStream(port_a.Xi_outflow);

    port_a.C_outflow = if allowFlowReversal then inStream(port_b.C_outflow) else zeros(Medium.nC);
    if m_flow<m_flow_small then
      m_flow_GUV = m_flow_small;
    else
      m_flow_GUV = m_flow;
    end if;
    for i in 1:Medium.nC loop
      port_b.C_outflow[i] = booleanToReal.y*(1 - exp(-kGUV[i]*m_flow_nominal/m_flow_GUV))*inStream(port_a.C_outflow[i]);
    end for;
    //port_b.C_outflow[2] = (1-eff)*inStream(vol.ports[2].C_outflow[2]);
    //port_b.C_outflow[1] = inStream(vol.ports[2].C_outflow[1]);

    connect(u,booleanToReal. u)
      annotation (Line(points={{-120,-80},{-82,-80}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={
          Rectangle(
            extent=DynamicSelect({{-100,10},{-100,10}}, {{100,10},{100+200*max(-1, min(0, m_flow/(abs(m_flow_nominal)))),-10}}),
            lineColor={28,108,200},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Rectangle(
            extent=DynamicSelect({{-100,10},{-100,10}}, {{-100,10},{-100+200*min(1, max(0, m_flow/abs(m_flow_nominal))),-10}}),
            lineColor={28,108,200},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None)}),
            defaultComponentName="res",
  Documentation(info="<html>
<p>
Partial model for a duct GUV trace species inactivation calculation.
</p>
<p>
</html>",   revisions="<html>
<ul>
<li>
March 29, 2024 by Cary Faulkner:<br/>
First implementation.
</li>
</ul>
</html>"));
  end PartialInDuctGUVCalc;

  model InDuctGUVCalc "Inactivation calculation for Duct GUV"
    extends Buildings.AirCleaning.BaseClasses.PartialInDuctGUVCalc(final
        m_flow_turbulent=if computeFlowResistance then deltaM*
          m_flow_nominal_pos else 0);

    parameter Real deltaM(min=1E-6) = 0.3
      "Fraction of nominal mass flow rate where transition to turbulent occurs"
         annotation(Evaluate=true,
                    Dialog(group = "Transition to laminar",
                           enable = not linearized));
    final parameter Real k = if computeFlowResistance then
          m_flow_nominal_pos / sqrt(dp_nominal_pos) else 0
      "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  protected
    final parameter Boolean computeFlowResistance=(dp_nominal_pos > Modelica.Constants.eps)
      "Flag to enable/disable computation of flow resistance"
     annotation(Evaluate=true);
    final parameter Real coeff=
      if linearized and computeFlowResistance
      then if from_dp then k^2/m_flow_nominal_pos else m_flow_nominal_pos/k^2
      else 0
      "Precomputed coefficient to avoid division by parameter";
  initial equation
   if computeFlowResistance then
     assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
   end if;

   assert(m_flow_nominal_pos > 0, "m_flow_nominal_pos must be non-zero. Check parameters.");
  equation
    // Pressure drop calculation
    if computeFlowResistance then
      if linearized then
        if from_dp then
          m_flow = dp*coeff;
        else
          dp = m_flow*coeff;
        end if;
      else
        if homotopyInitialization then
          if from_dp then
            m_flow=homotopy(
              actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                dp=dp,
                k=k,
                m_flow_turbulent=m_flow_turbulent),
              simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
          else
            dp=homotopy(
              actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                m_flow=m_flow,
                k=k,
                m_flow_turbulent=m_flow_turbulent),
              simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
           end if;  // from_dp
        else // do not use homotopy
          if from_dp then
            m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
              dp=dp,
              k=k,
              m_flow_turbulent=m_flow_turbulent);
          else
            dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
              m_flow=m_flow,
              k=k,
              m_flow_turbulent=m_flow_turbulent);
          end if;  // from_dp
        end if; // homotopyInitialization
      end if; // linearized
    else // do not compute flow resistance
      dp = 0;
    end if;  // computeFlowResistance

    annotation (defaultComponentName="res",
  Documentation(info="<html>
<p>Duct GUV calculation.</p>
<p><b>Assumptions</b> </p>
<h4>Important parameters</h4>
<h4>Notes</h4>
<h4>Implementation</h4>
</html>",   revisions="<html>
<ul>
<li>
March 29, 2024 by Cary Faulkner:<br/>
First implementation.
</li>
</ul>
</html>"),
      Icon(graphics={
          Rectangle(
            extent={{-74,80},{72,62}},
            lineColor={28,108,200},
            fillColor={85,170,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-60,56},{-60,-28}}, color={28,108,200}),
          Line(points={{-40,56},{-40,-28}}, color={28,108,200}),
          Line(points={{0,56},{0,-28}}, color={28,108,200}),
          Line(points={{60,56},{60,-28}}, color={28,108,200}),
          Line(points={{40,56},{40,-28}}, color={28,108,200}),
          Line(points={{20,56},{20,-28}}, color={28,108,200}),
          Line(points={{-20,56},{-20,-28}}, color={28,108,200})}));
  end InDuctGUVCalc;
end BaseClasses;
