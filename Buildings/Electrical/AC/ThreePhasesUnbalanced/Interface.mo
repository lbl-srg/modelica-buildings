within Buildings.Electrical.AC.ThreePhasesUnbalanced;
package Interface
  extends Modelica.Icons.InterfacesPackage;
  connector Terminal_p
    Buildings.Electrical.AC.ThreePhasesBalanced.Interfaces.Terminal_p phase[3];
    annotation (Icon(graphics={                Polygon(
                points={{-100,100},{-100,60},{100,60},{100,100},{-100,100}},
                lineColor={0,120,120},
                fillColor={0,120,120},
                fillPattern=FillPattern.Solid),Polygon(
                points={{-100,-100},{100,-100},{100,-60},{-100,-60},{-100,-100}},
                lineColor={0,120,120},
                fillColor={0,120,120},
                fillPattern=FillPattern.Solid),Polygon(
                points={{-100,-20},{100,-20},{100,20},{-100,20},{-100,-20}},
                lineColor={0,120,120},
                fillColor={0,120,120},
                fillPattern=FillPattern.Solid)}));
  end Terminal_p;

  connector Terminal_n
    Buildings.Electrical.AC.ThreePhasesBalanced.Interfaces.Terminal_n phase[3];
    annotation (Icon(graphics={                Polygon(
            points={{-100,100},{-100,60},{100,60},{100,100},{-100,100}},
            lineColor={0,120,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),    Polygon(
            points={{-100,-60},{-100,-100},{100,-100},{100,-60},{-100,-60}},
            lineColor={0,120,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),    Polygon(
            points={{-100,20},{-100,-20},{100,-20},{100,20},{-100,20}},
            lineColor={0,120,120},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end Terminal_n;
end Interface;
