import React from 'react';
import { TouchableOpacity, View, Text, ActivityIndicator } from 'react-native';
import { StyleSheet, TextStyle } from 'react-native';

export type ButtonProps = {
  /**Text to diplay within the button */
  title: string;
  /** Disable button */
  disabled?: boolean;
  /** Indicating loading animation */
  isLoading?: boolean;
  /** Method to trigger on press/click */
  onPress: () => void;
  /** Button size */
  size?: Size;
  /** override Button container styles */
  containerStyles?: { [key: string]: string };
};
export const MadButton = ({
  title,
  disabled = false,
  isLoading = false,
  size = 'medium',
  containerStyles = {},
  onPress,
}: ButtonProps) => {
  return (
    <TouchableOpacity style={{ ...styles.container, ...containerStyles }} disabled={disabled} onPress={onPress}>
      {isLoading && (
        <View>
          <ActivityIndicator size={size === 'medium' ? 'small' : size} />
        </View>
      )}

      <Text style={styles.text}>{title}</Text>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    textAlign: 'center',
    backgroundColor: '#16a085',
    borderRadius: 20,
  },
  text: {
    padding: 10,
    color: 'white',
  } as TextStyle,
});

export const buttonSizeValues = ['small', 'medium', 'large'] as const;
export type Size = (typeof buttonSizeValues)[number];
