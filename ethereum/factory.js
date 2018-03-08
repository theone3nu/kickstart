import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';


const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  '0x981C81bB0F252763AED34b6A56520D412B193522',
);

export default instance;