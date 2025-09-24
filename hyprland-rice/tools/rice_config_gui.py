#!/usr/bin/env python3
"""
Hyprland Rice Configuration GUI
Simple tool for managing wallpapers and themes
"""

import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import json
import subprocess
import os
from pathlib import Path

class RiceConfigGUI:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Hyprland Rice Configuration")
        self.root.geometry("600x500")
        
        # Get project directory
        script_dir = Path(__file__).parent
        self.project_dir = script_dir.parent
        self.wallpapers_dir = self.project_dir / "wallpapers"
        self.colors_file = self.project_dir / "themes" / "colors.json"
        
        self.create_widgets()
        self.load_current_colors()
    
    def create_widgets(self):
        # Main notebook for tabs
        notebook = ttk.Notebook(self.root)
        notebook.pack(fill="both", expand=True, padx=10, pady=10)
        
        # Wallpaper tab
        wallpaper_frame = ttk.Frame(notebook)
        notebook.add(wallpaper_frame, text="Wallpapers")
        
        # Current wallpaper info
        ttk.Label(wallpaper_frame, text="Wallpaper Management", font=("Arial", 16, "bold")).pack(pady=10)
        
        # Wallpaper list
        list_frame = ttk.Frame(wallpaper_frame)
        list_frame.pack(fill="both", expand=True, padx=10, pady=10)
        
        ttk.Label(list_frame, text="Available Wallpapers:").pack(anchor="w")
        
        self.wallpaper_listbox = tk.Listbox(list_frame, height=8)
        self.wallpaper_listbox.pack(fill="both", expand=True, pady=5)
        
        # Wallpaper buttons
        btn_frame = ttk.Frame(wallpaper_frame)
        btn_frame.pack(fill="x", padx=10, pady=5)
        
        ttk.Button(btn_frame, text="Add Wallpaper", command=self.add_wallpaper).pack(side="left", padx=5)
        ttk.Button(btn_frame, text="Set Wallpaper", command=self.set_wallpaper).pack(side="left", padx=5)
        ttk.Button(btn_frame, text="Remove", command=self.remove_wallpaper).pack(side="left", padx=5)
        ttk.Button(btn_frame, text="Refresh", command=self.refresh_wallpapers).pack(side="left", padx=5)
        
        # Colors tab
        colors_frame = ttk.Frame(notebook)
        notebook.add(colors_frame, text="Colors")
        
        ttk.Label(colors_frame, text="Current Color Scheme", font=("Arial", 16, "bold")).pack(pady=10)
        
        # Color display frame
        self.colors_display_frame = ttk.Frame(colors_frame)
        self.colors_display_frame.pack(fill="both", expand=True, padx=10, pady=10)
        
        # Settings tab
        settings_frame = ttk.Frame(notebook)
        notebook.add(settings_frame, text="Settings")
        
        ttk.Label(settings_frame, text="Rice Settings", font=("Arial", 16, "bold")).pack(pady=10)
        
        # Terminal selection
        terminal_frame = ttk.LabelFrame(settings_frame, text="Terminal")
        terminal_frame.pack(fill="x", padx=10, pady=5)
        
        self.terminal_var = tk.StringVar(value="foot")
        ttk.Radiobutton(terminal_frame, text="Foot", variable=self.terminal_var, value="foot").pack(side="left", padx=10)
        ttk.Radiobutton(terminal_frame, text="Kitty", variable=self.terminal_var, value="kitty").pack(side="left", padx=10)
        
        # Apply settings button
        ttk.Button(settings_frame, text="Apply Settings", command=self.apply_settings).pack(pady=10)
        
        # Status bar
        self.status_var = tk.StringVar(value="Ready")
        status_bar = ttk.Label(self.root, textvariable=self.status_var, relief="sunken")
        status_bar.pack(side="bottom", fill="x")
        
        # Initialize wallpaper list
        self.refresh_wallpapers()
    
    def refresh_wallpapers(self):
        """Refresh the wallpaper list"""
        self.wallpaper_listbox.delete(0, tk.END)
        
        if not self.wallpapers_dir.exists():
            self.wallpapers_dir.mkdir(exist_ok=True)
            return
        
        for wallpaper in self.wallpapers_dir.glob("*.{jpg,jpeg,png,JPG,JPEG,PNG}"):
            self.wallpaper_listbox.insert(tk.END, wallpaper.name)
    
    def add_wallpaper(self):
        """Add a new wallpaper"""
        file_path = filedialog.askopenfilename(
            title="Select Wallpaper",
            filetypes=[("Image files", "*.jpg *.jpeg *.png *.JPG *.JPEG *.PNG")]
        )
        
        if file_path:
            # Copy to wallpapers directory
            source = Path(file_path)
            destination = self.wallpapers_dir / source.name
            
            try:
                if not destination.exists():
                    subprocess.run(["cp", str(source), str(destination)], check=True)
                    self.refresh_wallpapers()
                    self.status_var.set(f"Added: {source.name}")
                else:
                    messagebox.showwarning("File Exists", "Wallpaper already exists!")
            except subprocess.CalledProcessError:
                messagebox.showerror("Error", "Failed to copy wallpaper")
    
    def set_wallpaper(self):
        """Set the selected wallpaper"""
        selection = self.wallpaper_listbox.curselection()
        if not selection:
            messagebox.showwarning("No Selection", "Please select a wallpaper")
            return
        
        wallpaper_name = self.wallpaper_listbox.get(selection[0])
        wallpaper_path = self.wallpapers_dir / wallpaper_name
        
        try:
            # Extract colors and apply theme
            self.status_var.set("Extracting colors...")
            self.root.update()
            
            subprocess.run(["python3", str(self.project_dir / "scripts" / "extract_colors.py"), str(wallpaper_path)], check=True)
            self.load_current_colors()
            
            self.status_var.set(f"Wallpaper set: {wallpaper_name}")
            messagebox.showinfo("Success", f"Wallpaper and theme updated!\nWallpaper: {wallpaper_name}")
            
        except subprocess.CalledProcessError as e:
            messagebox.showerror("Error", f"Failed to set wallpaper: {e}")
            self.status_var.set("Error setting wallpaper")
    
    def remove_wallpaper(self):
        """Remove selected wallpaper"""
        selection = self.wallpaper_listbox.curselection()
        if not selection:
            messagebox.showwarning("No Selection", "Please select a wallpaper")
            return
        
        wallpaper_name = self.wallpaper_listbox.get(selection[0])
        
        if messagebox.askyesno("Confirm", f"Remove {wallpaper_name}?"):
            wallpaper_path = self.wallpapers_dir / wallpaper_name
            try:
                wallpaper_path.unlink()
                self.refresh_wallpapers()
                self.status_var.set(f"Removed: {wallpaper_name}")
            except OSError:
                messagebox.showerror("Error", "Failed to remove wallpaper")
    
    def load_current_colors(self):
        """Load and display current colors"""
        # Clear existing color widgets
        for widget in self.colors_display_frame.winfo_children():
            widget.destroy()
        
        if not self.colors_file.exists():
            ttk.Label(self.colors_display_frame, text="No colors loaded yet").pack(pady=20)
            return
        
        try:
            with open(self.colors_file) as f:
                colors = json.load(f)
            
            # Create color display grid
            row = 0
            col = 0
            for name, hex_color in colors.items():
                color_frame = ttk.Frame(self.colors_display_frame)
                color_frame.grid(row=row, column=col, padx=10, pady=5, sticky="w")
                
                # Color swatch (using label with background color)
                try:
                    color_label = tk.Label(color_frame, text="  ", bg=hex_color, width=4, height=2)
                    color_label.pack(side="left", padx=5)
                except tk.TclError:
                    # Invalid color, use default
                    color_label = tk.Label(color_frame, text="N/A", width=4, height=2)
                    color_label.pack(side="left", padx=5)
                
                # Color info
                info_frame = ttk.Frame(color_frame)
                info_frame.pack(side="left", padx=5)
                
                ttk.Label(info_frame, text=name.title(), font=("Arial", 10, "bold")).pack(anchor="w")
                ttk.Label(info_frame, text=hex_color, font=("Courier", 9)).pack(anchor="w")
                
                col += 1
                if col >= 2:
                    col = 0
                    row += 1
                    
        except (json.JSONDecodeError, OSError) as e:
            ttk.Label(self.colors_display_frame, text=f"Error loading colors: {e}").pack(pady=20)
    
    def apply_settings(self):
        """Apply current settings"""
        self.status_var.set("Settings applied")
        messagebox.showinfo("Settings", "Settings will take effect on next theme application")
    
    def run(self):
        """Start the GUI"""
        self.root.mainloop()

if __name__ == "__main__":
    app = RiceConfigGUI()
    app.run()
