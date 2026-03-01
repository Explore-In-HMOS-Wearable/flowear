import { HealthValue } from './HealthValue';

export interface SamplePoint {
  startTime: number;
  endTime: number;
  value: HealthValue[];
}