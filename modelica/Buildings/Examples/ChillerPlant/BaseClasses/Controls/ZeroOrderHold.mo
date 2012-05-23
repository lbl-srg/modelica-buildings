within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
block ZeroOrderHold "Zero order hold for boolean variable"
  extends Modelica.Blocks.Interfaces.BooleanSISO;
  extends Modelica.Blocks.Interfaces.DiscreteBlock;
protected
  Boolean ySample;
algorithm
  when {sampleTrigger,initial()} then
    y := ySample;
    ySample := u;
  end when;
  annotation (Icon(Line(points=[-72, -48; -46, -48; -46, -6; -20, -6; -20, 18;
            0, 18; 0, 58; 24, 58; 24, 14; 44, 14; 44, -6; 50, -6; 50, -6; 68, -6])),
      Documentation(info="<HTML>
This model outputs the same value as the input for a given time of period. 
</HTML>
", revisions="<html>
<ul>
<li>
July 21, 2011, by Wangda Zuo:<br>
Add comments and merge to library. 
</li>
<li>
January 18, 2011, by Wangda Zuo:<br>
First implementation.
</li>
</ul></HTML>"));
end ZeroOrderHold;
