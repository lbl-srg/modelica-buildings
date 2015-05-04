within Buildings.Fluid;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type EfficiencyCurves = enumeration(
      Constant "constant",
      Polynomial "Polynomial",
      QuadraticLinear "quadratic in x1, linear in x2")
    "Enumeration to define the efficiency curves";
  type CvTypes = enumeration(
      OpPoint "flow coefficient defined by m_flow_nominal/sqrt(dp_nominal)",
      Kv "Kv (metric) flow coefficient",
      Cv "Cv (US) flow coefficient",
      Av "Av (metric) flow coefficient")
    "Enumeration to define the choice of valve flow coefficient" annotation (
      Documentation(info="<html>

<p>
Enumeration to define the choice of valve flow coefficient
(to be selected via choices menu):
</p>

<table summary=\"summary\"  border=\"1\">
<tr><th>Enumeration</th>
    <th>Description</th></tr>

<tr><td>OpPoint</td>
    <td>flow coefficient defined by ratio m_flow_nominal/sqrt(dp_nominal)</td></tr>

<tr><td>Kv</td>
    <td>Kv (metric) flow coefficient</td></tr>

<tr><td>Cv</td>
    <td>Cv (US) flow coefficient</td></tr>

<tr><td>Av</td>
    <td>Av (metric) flow coefficient</td></tr>

</table>

<p>
The details of the coefficients are explained in the
<a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">
Users Guide</a>.
</p>

</html>"));
  type EfficiencyInput = enumeration(
      volume "use state of fluid volume",
      port_a "use port_a",
      port_b "use port_b",
      average "use (port_a+port_b)/2)")
    "Enumeration to define the input for efficiency curves";
  type HeatExchangerConfiguration = enumeration(
      ParallelFlow "Parallel flow",
      CounterFlow "Counter flow",
      CrossFlowUnmixed "Cross flow, both streams unmixed",
      CrossFlowStream1MixedStream2Unmixed
        "Cross flow, stream 1 mixed, stream 2 unmixed",
      CrossFlowStream1UnmixedStream2Mixed
        "Cross flow, stream 1 unmixed, stream 2 mixed")
    "Enumeration for heat exchanger construction"
  annotation(Documentation(info="<html>
<p>
 Enumeration that defines the heat exchanger construction.
</p>
<p>
The following heat exchanger configurations are available in this enumeration:
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Enumeration</th><th>Description</th></tr>
<tr><td>ParallelFlow</td><td>Parallel flow</td></tr>
<tr><td>CounterFlow</td><td>Counter flow</td></tr>
<tr><td>CrossFlowUnmixed</td><td>Cross flow, both streams unmixed</td></tr>
<tr><td>CrossFlowStream1MixedStream2Unmixed</td><td>Cross flow, stream 1 mixed, stream 2 unmixed</td></tr>
<tr><td>CrossFlowStream1UnmixedStream2Mixed</td><td>Cross flow, stream 1 unmixed, stream 2 mixed</td></tr>
</table>
<p>
Note that for a given heat exchanger, the
 <code>HeatExchangerConfiguration</code> is fixed. However, if the capacity
 flow rates change, then the
 <a href=\"modelica://Buildings.Fluid.Types.HeatExchangerFlowRegime\">
 HeatExchangerFlowRegime</a> may change. For example,
 a counter flow heat exchanger has <code>HeatExchangerConfiguration=CounterFlow</code>,
 but the <a href=\"modelica://Buildings.Fluid.Types.HeatExchangerFlowRegime\">
 HeatExchangerFlowRegime</a> can change to parallel flow if one of the two capacity flow rates reverts
 its direction.
 </p>
</html>", revisions=
          "<html>
<ul>
<li>
February 18, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

  type HeatExchangerFlowRegime = enumeration(
      ParallelFlow "Parallel flow",
      CounterFlow "Counter flow",
      CrossFlowUnmixed "Cross flow, both streams unmixed",
      CrossFlowCMinMixedCMaxUnmixed "Cross flow, CMin mixed,   CMax unmixed",
      CrossFlowCMinUnmixedCMaxMixed "Cross flow, CMin unmixed, CMax mixed")
    "Enumeration for heat exchanger flow configuration"
  annotation(Documentation(info="<html>
<p>
 Enumeration to define the heat exchanger flow regime.
</p>
<p>
This enumeration defines for the current capacity flow rate the kind of
heat transfer relation that will be used to compute the relation between
effectiveness and Number of Transfer Units.
</p>
<p>
The following heat exchanger flow regimes are available in this enumeration:
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Enumeration</th><th>Description</th></tr>
<tr><td>ParallelFlow</td><td>Parallel flow</td></tr>
<tr><td>CounterFlow</td><td>Counter flow</td></tr>
<tr><td>CrossFlowUnmixed</td><td>Cross flow, both streams unmixed</td></tr>
<tr><td>CrossFlowCMinMixedCMaxUnmixed</td><td>Cross flow, CMin mixed,   CMax unmixed</td></tr>
<tr><td>CrossFlowCMinUnmixedCMaxMixed</td><td>Cross flow, CMin unmixed, CMax mixed</td></tr>
</table>
</html>"));
annotation (preferredView="info", Documentation(info="<html>
This package contains type definitions.
</html>"));
end Types;
