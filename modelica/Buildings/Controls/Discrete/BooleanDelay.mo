within Buildings.Controls.Discrete;
block BooleanDelay "Zero order hold for boolean variable"
  extends Modelica.Blocks.Interfaces.BooleanSISO;
  extends Modelica.Blocks.Interfaces.DiscreteBlock;
protected
  Boolean ySample;
algorithm
  when {sampleTrigger, initial()} then
    y := ySample;
    ySample := u;
  end when;

  annotation (Icon(graphics={Line(points={{-72,-48},{-46,-48},{-46,-6},{-20,-6},
              {-20,18},{0,18},{0,58},{24,58},{24,14},{44,14},{44,-6},{50,-6},{
              50,-6},{68,-6}})}));
end BooleanDelay;
