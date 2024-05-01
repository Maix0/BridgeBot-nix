#!/usr/bin/env python
import discord
from discord import Intents, app_commands
from discord.utils import get
import os
from dotenv import load_dotenv

load_dotenv()

intents = Intents.all()
client = discord.Client(intents=intents)

async def send_copy_message(message: discord.Message, server_id, channel_id):
    guild = client.get_guild(server_id)
    channel = guild.get_channel(channel_id)
    embed=discord.Embed(title="", color=0x000000)
    embed.set_author(name=message.author.display_name, icon_url=message.author.display_avatar)
    embed.add_field(name=message.content, value="", inline=False)
    await channel.send(embed=embed)

@client.event
async def on_message(message: discord.Message):
    if message.author.id == 1234963767566012427:
        return
    if message.channel.id == os.getenv('ID_CHANNEL_ONE'):
        await send_copy_message(message, os.getenv('ID_SERVEUR_TWO'), os.getenv('ID_CHANNEL_TWO'))
    elif message.channel.id == os.getenv('ID_CHANNEL_TWO'):
        await send_copy_message(message, os.getenv('ID_SERVEUR_ONE'), os.getenv('ID_CHANNEL_ONE'))

@client.event
async def on_ready():
    print("Ready!")

def main():
    client.run(os.getenv('TOKEN'))
