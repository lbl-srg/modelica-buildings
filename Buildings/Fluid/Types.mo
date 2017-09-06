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
  type HeatExchangerConfiguration = enumeration(
      ParallelFlow "Parallel flow",
      CounterFlow "Counter flow",
      CrossFlowUnmixed "Cross flow, both streams unmixed",
      CrossFlowStream1MixedStream2Unmixed
        "Cross flow, stream 1 mixed, stream 2 unmixed",
      CrossFlowStream1UnmixedStream2Mixed
        "Cross flow, stream 1 unmixed, stream 2 mixed",
      ConstantTemperaturePhaseChange "Constant temperature phase change in one stream")
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
<tr><td>ConstantTemperaturePhaseChange</td><td>Constant temperature phase change in one stream</td></tr>
</table>
<p>
Note that for a given heat exchanger, the
 <code>HeatExchangerConfiguration</code> is fixed. However, if the capacity
 flow rates change, then the
 <a href=\"modelica://Buildings.Fluid.Types.HeatExchangerFlowRegime\">
 Buildings.Fluid.Types.HeatExchangerFlowRegime</a> may change. For example,
 a counter flow heat exchanger has <code>HeatExchangerConfiguration=CounterFlow</code>,
 but the <a href=\"modelica://Buildings.Fluid.Types.HeatExchangerFlowRegime\">
 Buildings.Fluid.Types.HeatExchangerFlowRegime</a> can change to parallel flow if one of the two capacity flow rates reverts
 its direction.
 </p>
</html>", revisions=
          "<html>
<ul>
<li>
March 27, 2017, by Michael Wetter:<br/>
Added <code>ConstantTemperaturePhaseChange</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/694\">
Buildings #694</a>.
</li>
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
      CrossFlowCMinUnmixedCMaxMixed "Cross flow, CMin unmixed, CMax mixed",
      ConstantTemperaturePhaseChange "Constant temperature phase change in one stream")
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
<tr><td>ConstantTemperaturePhaseChange</td><td>Constant temperature phase change in one stream</td></tr>
</table>
</html>", revisions="<html>
<ul>
<li>
March 27, 2017, by Michael Wetter:<br/>
Added <code>ConstantTemperaturePhaseChange</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/694\">
Buildings #694</a>.
</li>
<li>
February 18, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  type InputType = enumeration(
      Constant "Use parameter to set stage",
      Stages "Use integer input to select stage",
      Continuous "Use continuous, real input") "Input options for movers"
    annotation (Documentation(info="<html>
<p>
This type allows defining which type of input should be used for movers.
This can either be
</p>
<ol>
<li>
a constant set point declared by a parameter,
</li>
<li>
a series of possible set points that can be switched using an integer input, or
</li>
<li>
a continuously variable set point.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
April 2, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));

 annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
